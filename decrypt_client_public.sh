# This module should run on a remote server
# and only return the decrypted key

openssl rsautl \
	-decrypt \
	-inkey server_private_key.pem \
	-in client_private_key.pem \
	-out client_private_key.pem.new &&

rm client_private_key.pem
mv client_private_key.pem.new client_private_key.pem