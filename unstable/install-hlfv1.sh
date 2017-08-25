ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.12.0
docker tag hyperledger/composer-playground:0.12.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Є�Y �=�r�r���d��&)W*�}�r&;㝑DR�dy����ZcK�.�Ǟ����D�"4�H�]:�O8U���F�!���@^��Ւ/c[���~�%��� �h�Xk!;��v;(�1a�ac�������a@ ���4.	��)DeI|"FEEI��O1&Ŕ'@x �ׂ����kî�,ƻ�����vlm���s�s��54�lr �N؛�3�f�а�}j�6�=e�6l��f��l�dG��'T��v��:>I B����!l�?�Y�����6��!Rj���WɔOS{�l>�	~
 p9�D�נ�;�&x7]>z�F.ԡ	�|�E�G0�}�lUo�j12�ll�Tܼ�	�*H��K+���L��j�b�[���n#CL5�e!��]��a��|�<Qi.Q�}�ݮ��f�lC���:r4��Pڴ��X�@�U]1,\G�%Un]�:��B��b��G���F	�t��NFр�s-_���G�9*��a[G61��xq��hy�IEo�m3	(��9lwLD[�a�S,V�kZ��jE�;jXtM���ɧi�=�!*���j�[0�	��t�i�ØНm�|���sN��]��6�z���G9�Aywb�)uanK�S�M�%�|[��O֝�9�	��g�W�c��Bn�-6��=3�Hй�l��iez;p��=!/|��Q7D'����A��x\Y�Q�QZ.�bT~��d|��ߜ�w	�p��'հӼ/6����%���UDYbd��_��ˀ��Gj��A��9س5�g/����aS7I>_&���ieʼ>x�΃~ ��N>ENMI�A��Ks��r�c����p~V��+�_���ˆ9�߁Z6P���փ�`����?Qj�rL�(�'cr4���e ]i�V�W����`���a!�����1�� TX�\hϺ`�>�c�,к���F�N�Ϧ˱�o�6�Х����X���s��v�0��in�ʝ\�;dK�4�]�F��Q��N��炕(=���ٍ�TP×�44d9��J���BR�Ew��2T/��	�C)k&�ZZ���x��P�
�!����X3����HB���q?�<��C�֚F�����P���{q �kq����D�*�S���'��MVj\�#1,����Gd��'��'�:�F��>��j��|p��O5�4{;t����O"O���d1�*��K�(��K����{
h���v��ۄ.h�	���q�Blϲ�1~)�p�J��;/ֹK�����Й
��B�9���hr_$��[����ה�E\Қ�;��	۫|x ~�~���`30���d���A�K���$wi!�2m��m��m��P���^̎:O�{K� �"$F=棰>�`�8�o7�׻N`�J<!�O K�c�h��'��H�v�1�y�:Ց����TE;3�-��:d�ti�4��*.}:\�"}���\��+y��*Q�uL>��&�(�ۯD��}A�HsA�ihM�Yd~<�t�^0�? �وz�|��<eƯs���[@���d����Q�,�1����,�ufN����^�#�p!�]��j&�C��#j��-����T�3�SEz��
w���)qq5�/V�?_6̱��X>�����e��c��D��QZ��R�����}?:�������P��c66y�F�9�� ͳmJ�x�`�ϥ��Op'\u;_9��������oBA5��cٕ����g�ȃ�T$,�.H��U��|��0S����/��9z��� �r����צ��B���\����D2��&�H�ϟM?"�ҕ�Uy+U�\=������b�����.*����`����&L���4.����?�B�/��SyD����w��\�[�l>| �%	.��	�$����5d����,,"�K�䆆�v�BЭDɈ��H����?����"�˙�����\4\����3�9���t���K�U��e����݇\ �d�QQ�]��eae�ˀ����F}O�N��P�Fu��qBx$`0���νa����K��q��qA���.n�¹����������&(��_�v��s(������?� Q$*@�?UV���3�3t�-�� ���+б�^����ҝ0GW�!Խ~�'��@�l�����}��$ݛ�O���6�Ǉ�\�Q��(�S�\A��K�]W��1��V�T.*��+JkФg�\�=�� d���&nƑȆ����g�Ƿ^"?N0b��4�#0��� L�ݝy�L���L��I5�3���D�ZEP_$�����P�M�\�����hl����\����@\��,dGD�<�o|g�G~h�ɳ��V������Ә�BX���!�{���ܻq����k�u>i�ok��9p������	��%E�W��xT�_N �N)��F���fxx��1��Ȝ����o)T�����Ѝ�c����_��\�����?w��Y�C�]@i���n Hӝ��瀴�L����-".uQ���AÅ�� ̒ � 㦁�i�/\Aj���� ��?ݲ��O�E/n�.�d���yI.�K6`�*�-���q��"A� SH��c6/�T���ܘ~#�1'��Lj���2���fȘ�c��D���d�yv��W��MssҔE	R&���QA�G� 8%3���P�@:d�DV���hGeэ-�j���t<�7�����x�}�_���,�<�c'滧�{~:������43���H��o�����)�ᛯ���7�������������(Z4Y�uM�D9뵺�m$�z-!�R"YDrLN�QY�rBI$�Z|C�j���_s���%����+��j�c$~!������tz[{��3�Ka���kx��Z�Gnm8��˿�������4��ꛯ�tx��Kp�����}�k���?�&���_نK��׾%H3*��)#z�`'(������{�}�����N<n��%R�H2{�G\���/>q�G9&o���/]�n����2XcMf�KC'e���0�(�I���u�~0����'O��3�.�7/y�h�ݸ<[��}�"�2�5�c����7��F}#��\���EQQ�m�PТ��Aq#51aʲ',��K^Cĭ��,@������E�ʔ��l>�V3���U��S��TJ�R��O��|Y-z{�a�e_�$s}�6n�L�,�R���>�_�	���.2����ʩ�A&�,����l	�j�Ul�rf�}����y�L=�i��!yf$s�-����%��X�8�Uշ>�fr���E�;y�l��&���rV�����
}�B5#����\��vS+�Z�x��
ռ�W�KG�쌕	ò���Y�V(9�T�8}X*�2�7��j�tm]*Y�)IY�t���9�f�
ɒ���B�u e�|�|����ų�E�^H
C���JGe)*��PQL�˺Z���m��j��d��K�?�*9�62�T*���l�B^M漍��dI̵�+��!��Ƌo�㝣3ō�I?��o���n��0n���pG��B�bJ!~?����J<���r�D��s���Y���-�2"���e��^���v#�h_o�I���Q�T��rh��|��*�v�|�m�@/��'�-������?v���po�R�X���(�D˽��G-##�R��Z�����b�T��V=F��H(G�H�:yO�T��z��nJ�4򍊲��⛾��8Ӂ�|���{�������>�~JNĻz�n����g��9f��p$�y[�]�j=�����l���/����Q, �bL�=��$�����{�M������}}w�����m_��������3������e�D��_����d�Y�\!��&s�z���	=Hc�R�!���nr��Ѫž�N��C�"�E�ܑiv�li坒%yMr�T�lwSN�X�ZY����8��)���Ʒ�|�:��J_ɚH98ܖrF#�<�0��{���F�^7�]P%M\H}ˍf���ܽ�ˁ_��/_�������l�W��M_��_��/͙�����������ͧ&��l���o�)�4�
I�%-]j��ٙl� V�o
�G/��M����o9��=�Z�y哷�a��hb��Î���ۺp-�m��=q�1z�Bb�c5�y�V[[���d���~;�	��︘,��p��W�n��X\�f�YX���R�)H�N�f�'���fw�@5MP�e(#�z�{J�b�߆v���!/�n {���<�z8 ��=�Ҟ�pxiT7,����uz�Z�ېv@Z�A������uvC�!E����������@;��o� H�64�M0q���?4oJ��t��F����h/�2q�A���D.	�I&���趱��?���+򰽷�bz��QTx(�c�oC|T�e�ǚ;{<�����X��-=G�6Y��Q&Yd����5D������_��P!z2�g}��=��l�Wa 
x=8ߣ7{�b��H�"�}�E�|k�)tX��Ahh۰O�B"�k�!�3d��)oǠ"T���*L=���3��2��dy��Mf��kEyh9A�W:��	:)�g��u��s�\g��	ʯ�ͣ	mG=�I�c:��gDph�T��/����+t�iS=v-��a��0��k�`�_K$�M[��ҷ]hz��u��0��#���JĄ�����U�.2��GS�	o;;�u�I�������,8��7er�	����$6A�3b�w�t�-��,����"ՠ�������Ͽ���Ʒ���HM��m�v����#�=F�N.��� S<8���U+11n��F���M��Zu<)�YnH��1�����%���G%d3!x�*���/��|E,󵥣s�B���f�Lߣ�O�R��ڞ��������zx���X��7�+��3�C�J�=ףB��fz�"�+��`�@�̀^���L֔;l4lԠ���1�\CS粉G'D����F���=&��MӠ?��<��T�|��m����[7��M��
�&C��>K�3��y:L����⣙Ӂ�r�?���SJ�V 5�>s�)����3;�����]K��XZ�i����4��.�n3ݨ�{;��s��c'q*��y�(9���<*v�$tY �h	�����Y��alF Do���s���ǭ�7uQ紺n�}������?�ؼ���n,�5����Uehkh�	breW��1"���Rx���KB=G�_R?�����?W��;�����{?S������o~�ٿ�~C>ǐ�c������}��G?�X���l�B�?�����H���1*�`D$J��rK(IE�� �N'2.c8Nv�x���/$�=}�+���_�u�?��K?��O�V����g���H�"�|yk��5B�~�{��؆����s�������|�|]�C�� ���?=@~�ŷ���M�C��b@�� ZLxh��mz�x��Գ��B�U�a�SFU/z��B�Tb�sf	�U�m�U�
	��Z�q
���nT������b����"���ƅ��\8/��yK��-�g%�"d�yrIgZS���(��s��s֘m���� �h��PnZ)��p&�C ��0�k����	徕�`�Sn�����s�ѬcV;]�6�)�-+��<,�����
�;���~	Ǩ&���}�_�f�@�]��jp-Ҵċ��8Ŗf��Wٱn�I�
�R��9�2���*؅5S��*eg${R�+�"�Y��Reh{���@��1���G��i�I�?h��`f��\�h =[�c9+��Դd�1�S3��ME�B� �,i�F5+��"�������Qd�v�e�W���9�W�M�)q�`"�D\'��Z�JM��1�4��\��j�O7�N���Y�R5�tz�g�6%�frʏ�CJ]!^3*��l~�]����t�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%�pyc0� oT24z�$��?\�(��c_�p���������VD/'��m��ߋ�YQ�\������.��L�֪��v�'ne��{�y+���N� ��i���"5F��Xv�3x壦k��j�|��R�(Q��}�-�.4��v�D�:O��D�ʖ.'��	����H�%�z��x��y�O�5���I:AD$$Q��e��:�)H����:1���h�ta]�~rtfF$
2�R	J���V�`���6�jB[�Q3��~���=c�|��+\�pZӨj�Z�t���R���&�85��2���_��N��^}:
�i������no�֟_ ���u�޽����o�}���tn�%�&��G��Y�>	�}��Б����n>��^��5]��������쾼�Z�5�������Q������H�#W���|�'���GB?x���{��ϯe��-�di��y3>+�����"���J�v�t�$�h��b銧��&�w��#XX�"�CɅ��jl��I.�6VsPr!��*Y��.�ܔ���z� �o�BA��Ri�Q;�������x�RT3+���R�ؔJR�cv\TR�%$A���TN�|a���̱6�[�i�C��A[��e�[mĻ�ec�ʪ?��FX�B"]p�L�x����'�t{9-Fmr�w���A{�i L3���� �jIc������QU����q�v��RztaK���m�*�^���%}��)J5��Y��5Zk(�~��ncb�:԰��4bD�Q�-5B�ђ1�W�b!��.��Qb��c�J�Е��l����Y���^A'>��_e<��k�&	�o(��Y�竃�0��x�`��^y����/\�W���n�@N-�g ��|�ӏ��U�`E.*��E��[���"���g����Y�s.�;r[~���6�9�t�g��~��OK雩p$��\f��s�4�z�h�TI/�x3m��|�Ŗ�Ê�ϡ���V����2�g	�)��e��fo�.J|�Ƶ�ym�i�Ҽ���ء�Z�-�P�C9)дu�0�9�,Y��V냹@��R���Tf>S���8V�]��{:��"8S��kj2��TuŮ�\�{� MO;�xQI�jJ6S�Uy�e+�Ya�]�H-����e�f��x:������bt�3\X&WI��~8��%r�.KO��&��ky"/E�X)!?��Æ�
X���=)*lY%V�ݯ"Yi�U$�g?��m�`���	r�#O� +;�Je"��1O���9�)$��^�T��h�Z�&���W�R$O���KL�t�?�ݭ��Y�T�U�[�cL��D��GI��ayJ�VG�^:�/�ә�ė�	�(�U(��Qv(�X5�/��L�b��$+C��fgh�D�+���N��DqC��
��{9�g0�Ȓ��|��r�N�D��H̋�l�:N*بrl�0��J�U�7#Siж����e�š,�/�V�SOT
�^�b&�.����_}۶��wBoM7��ۍ7/]��7.�����<pmѲb���*:�2>�E��i�24���+�wCo"o#}�gy��#��^E[*��Bo!�>{���ٳ������0��8J
�z�����)�|èI�&;>$����$��J����Ȼ� !ki]����G\���1�p�dJn�
��9���;�_;}���#ﺋC��D1����ȇ.�)�)z��t/r/�r����wHwI����D��f�_������[�������������`���z���q�պ]��\C�y^��h+a�͗�=;3�o?2\t�����X�HńNeG^�qH�� x#4�����8��}?}��M;�ٽ��a��z �w�{��}�:�
c-C!�.]/�������̺^d�c�v�״��9�*s��';���\@혚��[O��їE�t����� ��@H����aI��Q ��AL�ͦ��uln ��	@���݃��Rߘf���?6i�-��� �.��Y�K'�0o���h���b�,0( �r�� ��Sg��Sӓ�e��
��U#��I 	�����;X⣰K?����s���Nop�� 6�~�h�'*����*Ù6��~�5�>�\�6��Dj���Y@����_��)X��'�M<l+MN���d�ܡ����5��+s�:	�]BG~�WĀ�Mt`���X�N���&��G/���VB ؆ŉ6�hcI?	�Gv�'0\Y-�����	�˭~f@�����9�ۛO=����3;��\;ؐ�_����aS��_��l��UM��dd�׳j�������Е��� �N�
��`iA�덺<��]p���7�a@��0�27�js�'p�-`��)� ��$~y�K�|!��t��qq��"�@�fK.�m�xhHN��V�>aPҺW�&���+���h�R����]E�>����u ����w���=�L�t�2�]�?�� ��Q_��%v�6� �8m�[�'<_����O1��1��_i P�P�؏A?-Iq�#�T�n�����Y�I7�k)�΂�ݍ����2�(k��I .�rXǚF��a�)����6�v5`W;V&{( ?�=n�ܭ�!G���m{���n�2Ӟdg������A.��~d9x��^�h�nK^uqձ'+�6a��6���&ػ"���Ŗ���/�a�{l|��۴�#ƽV5���-B$�M�6��[�d��N��|��]M���SwFN��Zf&�>Pv�ùt���H�P�fu]�����;x�0_<�Q�#s�6����{�tN�����y�i�uq�/:�������45�ܿ���8�6�P1�Ѥ�ʍuK���5�c�QR@q�Gw��w�_�b�z�����s��m�Ĺ��k��� �ˆ�o���u?	�8d�O�O���q��17Y	���$V���.Z�h��'ϒ���U���>�(w�p�W��i���E>���z��s7h|�m]��1�8�d�\��)�|�v$��n��ڸ$��XW$2�D�.Eu;��ɱ.&Ix;j����v��MPA�	��3��H2�����+N����c�����N����8&o����	*r�Q�X:������R�"�v�!⑘,������$�����ĩ���2�!!E홌'"�`%)�Ą�� @'���
?�?��1�����'�so�;zr�ѸK�F1;s.���b;㮍���;2^ò;�^ʷ�2˕m�Nsy�L��r�t��q���Ҟ��g�+"��Y��U*O#о�\��[�+'f
�Sx�M�����_re�A%�P)�����u�A���.��w�OV@@��{�3�Ϡ����#p����jfoچĴ�X�\빨���`���wP�C��t�M�Z��<��E�;L�v��3d����d7�_q�r9�o� �����2�<���gE�+oP:|���|>Y`W9�`9��^�Zθ<[,�y��t��OPW�љ4A'ӡk^=1�
K���l��� )��c�K��.m��-$O���BEL�)>}���z�|*أ{���Y���z�k��Ing��:�i1��4��>���c�vيH���E��+��$���2W�O��˸cr��&��J&���P�u��I������k�O��n(��0��H ��;vW�Dt�NSwg��>x<��&�ݬ��ηl�2�-W�+X�����l����<m�߹$��G�����jy�3Z�%����eΪ���f�<P(��t���ǻ��Y�ɻI��U�_�ĨC��}�;��6��h����i[�����#����зY����a���^	��$���;r��������ԍ�t������������������*��l�2F��>Ҿ�?�y������lڗ����/F��m�����t�@s�@s�@�B=��7K?Wz%�?rG�������/�O����*�x��˘-;,"��Q���R'�c��G��h'JƢ�W�Y�\�/�:���U��G)l��;���K
��a2�;���=nhCS��*:�\ �5�{�f����*:-D�MC)�k3N�*)T@/�n�k�X��4g�U𜩷�|yQ<�ǫ�9��JěJ���O�N*���D��'==��E#	e֐�a�7Fu��؟�����O���?���_z������8iw�����������^��Gv��G�i_��`�}�+��� ��_�o�����A��#ݳ�0�����t:�����w�o/�������Kz�?���@�S�����?��{��$�-�����Gz��?�#��%����][s�h׽�W��V��o��IEE�7o"�	���t�gZg�Nw���^W��IZ���k～�����?i����*�	Gu�Q���Ο��x0�	�� ��P����?��C�����������~h@��g���O����
�V�[��?�|��T�A��n��
��ɗn!����������:��O�gv?o�aF�x���m�{��gQ��OfU0����ϗ�Ole�;�~��Z�w/�f��-��f�z̡pv�,׉�`.4W���::��~�;�U�-�V�<�Į8E���^�Y���}��}b?�������q�<�GG����u�b�����&�7ݮ�lG��ާ|�/�kwy����,�k�l$=��7⌖�Y�LK�w�e�=Y�.������b{ˋ�,`������Z9*f�~�����4@B�A��6 ���D��P�n���C��6����U5����?�p�w%��'���'������H�U ��'1�����?��C���?���
 �����
�?��ׇW���k�|���3霊�A����[�d������[����?��_����.���e=�Z0��P�yւu4���n4#}��;x�겚�	ņ���$-.�~���9ݟJ� �C����i��SY�����DC,��z�y'@6D�ПK��$[���i�c/}������/Z�B���$�S�Kn#%����ʘr{ɤ$����6n���w�[/B����b�'�Z�m�&��ґ1ژS�0���x���U ���.�!�GP�� ��?��C����>O�_���(��l\8g�Y��Čᙀ��� �#:�.�0�X�g�����B6d(�
��3~(������������˞�/ω�����by��})���(4�S�Y���.�����g��D�@]G�'��{��#!gml��y���<�N�6]l���{N��XM����%JgA֌��}8n�g͟u ���@���������a]�Z���������Om@������2��7�����>����hZ�s���i;���Ǝ�pΊ�����^�K�[������S{�WGr<h&�o^r�+df��Ses��;	e����*ƇqN��TqGv�.����p��`�<�-U�u����[������& p��?���������������/����/�@������H�?�����
������b�[�� �mY���f���
�&�yz��?[֒�_������v�cW����3 ��'� ��z�� W��G�p)>T����W� ��<���.6�CJ�e�%W���ϱA�Ք�n��Zۥm+ö\�d#6���ODu�����^>�wUo�~)���f{a�Ş�@ߍ�//����z�� �ے
C��{)V[�U|b���I_�4�x���HR�(�n$�,�xޜ�)������?o X�rk+���V<�Ԥ�I���?i Ւ5u����������-C�1��)I�sE�m����v#:˗���H�HhFv�w.2Ŋ��&5:���3�|�%�h�/+����"ڋ(�?�~��h�U�����袊��Z����x��a����������W�J�2��EU�������?���x@�?��C�?��כ�D��M�D����N�87�g�!���,-Dγ|D���v�O��"����#X��0�P�?��š�S	~������R�\f�Yx�1I@�F�|V̂^��]��A�}����J0�bup��^�Vk{�q��O�b�m7��ϒM���qR]X���2bqѥג����c�.)��{Y������Ԧ�o
��~p��?������P���������Y���
 ��������g�2�Q�?���O�w���U���_�=�?h#����G��)��*�j��������c;2�YSj_�	���jm���e-�ߊ������~f����3�߷V6����E1��Ã?f�ǝj��^��ny�,YD{u�c��N�9I��x�Xe���NW�l{��[����E����$a�㼬Px��ܘ��G��v\�KǑz�H��[/Wy�z�]�N��a�[��=��I�$`�aoU�]���P���=.�X#!�L�����Tv,�+k�L��b��gѼ_
�Xh.�^�S4&��c�	'y֌��ft6ݘ��,m�j�Za���&#�3���"�w���PDz,�2����j���	��?8�U@����
�O�քj��Q
����o
��*���7���7��A�}��;�s� ����[�����������CpP����_����
@�/��B�/������������?�_Z��<F��=�?�%@��I���)��*P�?���B� ��������P3�C8D� ���������+��5���v�g���� -��p��Q��h��� � ����#?$�q����GE@@��fH����s�?$����� ���?��� ��G�4�?T�����������I�A8D����s�?$����-��p���D�� �����J ��� ���Po��@�A�c%@@��I��u��ϭ�������_���H�?��W����0���0���.�
H�?��#@�U��*��tA�_���������,���%�'����c�9r<��s^��!�@�TD��|<�h<�	���|_�i�����'��
�O���5�O��`����tu�R��;׊S��
Tj��,+�q���$=M�B�
X��#�&&���קuK��r�[[���,���I�-�f��*[��5����i#�b��܋5d.Lk1�C��X^��n��>�~(6�x�)�6�d,RC�V�ݽ���pĀ���?�C���������?��	����ڀ �?��?�e`�o�'
��_}���� ���8������vh���Yf�}�?[��|�������N�:�G{m�M��p��~�͒�Q���������L�[ڮ�N�R����4;���`g(�>Efͨ�)];*��r�P꿷��������V����G����P������ �_���_����z�Ѐu 	�w��?��A�}<^������W�'u�%��=��'V�<�Rl����k�Z�=k���S$O��D��@�-T�s���	��v,mw�Y���fJ�'Z'��C[?�^<f�aN��p�Kv)��A�ͩ�4/I/f3���}�7s��ؽ��_��[��ӥ�o���ے
C�~�R����N\���@���N3���>�$%����FR��5���I����I�z~�,��j�Z�;�NP�Ņ$��$�~���i�mν�7��G���<]L$m8�Q�V���F����И	"��Yg�4��Z5�ی�v��]����t?������o���4���Y
�(��U�#���|������OP���(�� ���+�G���`�YTq���i���%@��I�������U�����L�P��c����w���*��g:�,�.��?󴱲�$�!H��§��\(�:�����K��L~�,M����\�K�t�����]<Y~�{��x���o��U��oq�޺�)~�.�7���\�RK�?ǖ�ё���ӪI�\WC���@���R�;
u9k����؀���*��6��T9�c�?y��ŤZ6���ע`O�&#z�ɮ]7-�Ժ䏧���>%�b���-�d�=�o������^�B���������{�a����i��gb��V"����ΎjH�n[~D�ma��S�c1�eD�Ce��|��8߹̱�I�\������2Vp>�l4=G�L��@<m0zM2�ڍX���m�Ra������!��U��T����p,�}e�W_��H�?�n��������ܜ'h��TH�קi6�8M^o��y�є0�).`C&ģ@ ��lvP���������*����W�x.v��Q$�:�1՛���`��Ǩ{���g��/���r��j{�\����+>��3���a��*���#8�^���W	*����0��������������ʛ������;y"���T�ᄝ��;��w���¢�e�N-�'��f�a���V_������n���obH�����^l?�m��E%�cI%��pGVf�%D���	�����!��ׂi��l���苐�M�y�.g�s~>.'�V7N��;��~�{}��{����ZnIlƉ���y�ฃ�Nw��/ʴe����MW��c�}?1�D��`�g�n6#w�	G�&�k��Lд���-BL��V#�3<��9�\H�hA���w���ڲK7C�X���E�����{
��|4�������?�!F,�85�I�����#���y0>��>�_�Kx� 3�`H�$��3/P`�} ���?��Q,���W�����Dd��s8�YP��Zo��a�Ǖ���uf尓|���^��T�^���[����[��;�?�"���(迫ڻ�8�*P��߿���	�H���n�����P1�?�@@;T����������������o�����i��i��2������y|\���_������������V)�^�}T6��%D�� ��⨔�L/�R����b���s��s���w�?nbK�����]ݕo7�W;+��~?V�0`� ������ݝtbϤ�I8L\)��`��=U�T���^2Zʍ��+�[��^f����+�������2��]Wy[	/�u���V<-�q䎫�x���N�CO�h�k�f�����V�(��nwX�SuUa0�װ�Y������ۮ���+-WĬ%p���j�э^�������e�G�)I�2��n���3����t;��Tk����w~���Im�F�í:r$Ek^����uՅ��wusR�X�ldi��j0�����&m5���YS�z���
Ne����b����ʼ`��1��~yA�4�"��e��v���7�e�`�Q������LȢ�7up��
���m��A�a�'td���?r��_��E�������O����O����G��O9�0�K���o�/�����X��\�ȅ�U�-�������ߠ�����`����������,~������lȅ��W�ߡ�gFd��Wa��#�����#��3����Q_; ���^�i�*�����u!����\���P��Y������J����CB��l��P��?�/����㿐��	(�?H
A���m��B��W� �##�����\��W�R���� ������0��_��ԅ@���m��B�a�9����\��W�R����L��P��?@����7�?��O&���"ׁ�Ā���_.���Q��2!����ȅ���Ȁ�������%����"P�+��~h��������˃��+��Ȉ\���e�F����Yfh��v�����v��Z_�(��L�6�z��e,�L�E����я�uz��E������lx��wz�(u��<}������BSl*�q���L9�[���׉\2��cݮ�q��ŝ�E�b��-Ng�A���z�v�z0r�=�nJ��p��4=�ݢ�6肸�"b��6C�VXK��C�	��kb��q��T嘣<Q�yŉl�)I�Q���Y	4���wuQ�<g������@���k���y����CG��ЁR�/_�����[�~Ƀ����������Ӥ�]�ס��D$�����i���8�i[�wqu�s����.�V�y�=Xm3�{䶺�P������
G4گ���~��[��Il��p��b�]ce5�.�����:DC��S�'���V���a�(�S4ß�Q�F�"���_���_���?`�!�!���X���c(����������G���r�D������Ud��;?��W�~w���)VĪ8S��X��ف����6��h�@����{�.K�l�?���E��uc4oޤ��D�0.L�d\��iϱS�ʩI�˓M�N�=z�\��w�]��a���K�"n�s��.��矲��a�d�����grBё�b׬<�)$SQ�k�߽"<ق�K���F_�]>ܔ���:o��^�|�+�OMm����%�N-wz�U�jso�i�m�Åu�l*S!i��aZ�e	S��c!��PH����fi��c(��%mS!�v����Oo�&��B�'T����y��)Y��_��#o���dA.�����Ń�gAf����u�?�����Z�i���gy�?���9	u�9�����������?��\�_-��-������܈����Lȓ�C���J�����9��?~<P��?B���%�uc��L@n��
�H�����\�?������?,���\���u�/�������9�C����ƥ}{�bG[2ߛpsۼ������I������O���
��rWO��/��J��9�{C��)_r�/y�/����~�E7�׺≪��'qZ�t�겋��3�����joH՘�
�������icXf(I|�1BT�ǧɦ�9�h�s�/��y�/i�؍�_ݐOW���R�F��u��
�s8V�վ��tu����_��X�Ug��`1�lF9�&<���%i됬At��j��X==j�h�2�Vl�X���`�Va��cu�1��6�}"<��bu?���`����W���n�{�����r��0���<���KȔ\��7�Q0��	P��A�/�����g`��������n�������r��,	������=` �G������%��R9������m�~������)���r�����:�}�?I�ex��77���_��, {��C@im���1d:^]���Z�M��}M���v�����Y|�oE��{�DU��4�-��т���V��V�˲J6F�� `�$������ �,��IOP�q}]X��@�R�������R8O��[~хE5*�֞,]I٨�i)��V�-�e���v�&�H"�28�`���J���ӻ��L.�?���/P�+��G��	���m��A��ԍ��E��,ȏ�3e�7�"oۜn��n͋�A�,ip�A��M�d�l��i�:O�6kZ�Y�O�9�}���ߟ�<����?!�?����~��]�+��,�O�H!O��S�Q�Mf��f���4.^��<���&�{�`�.���
ND�sV�5��X5YNQ�[��\�N%�.,OÎ�E>��5b�Ld�.u��rٍ'���[�C��?с��?/���<�����#��?�@��ϋ �n ꦸK������{��x�/�U��h"1'�
�b��Rly�V#�����č�����KGv;l� *L���5!%T�>f� >��;!�#ި�b~ly�]����d<�����M�����ch���J>����/�g����������E��!� �� ����C9�6 �`��l�?D|����?G�h�5f���}�&����-�]�t�������i�}[ ������ʉv�Z�⭮w���N�V���醹ZT�Q�E��S[Es9+�����p���Z�<�O�ި�A�5�4+��mq�����S3;�y�.$�'>]�ZO���ք�<&)BwX���y� v+a��$:=�փRI�⡡�dU2�ٶ�bM�Uv�L0���(�g᫃��Y�&��t�O�Z��m��^�>+(�T,�J�{Z�j�)�#��-�%��C�vfǖ=��Du��Fc$��"�7ܞ�����F�6s����Q�i����_��?�}c����m}���dR�����aA���ҝ;�����P�-��s�������oRE=~�UA��{�����گ�t��_|8�!}�][��|�/���~M�F�����],�}s�?~�����G��Ϗ(-tϳ�/��B+=��7��5/o�w,��Z��/�������y��~J��Ӗ�h�u���?��>�i����ς�a�a������7�}��0�q+���x�^���������<z�"+����3J�x��ps�V���-3��#VQ{����_�9����<}c���~�}�=�I������;�?����'$��UzT��#����݇���(������}���>�������������|������x�X�ښ;V�_	<��'$���L==�o_�/E*^���\��שD���߸E;�TT��7x?P�r{8����zx�&o�1��0�\��/����w,Z[V��[ӳ�����z���5��`�x`Y!����Qz�eܼ���o���œ,�����znnMb��u�%���|���SJ[��E<~r�-&�{���,��7��ݪ��SGuu�$�]t������y�woj���t��/��+;�я����]�3                           ����"��0 � 