DIR_PATH='./test_files'
files=$(ls $DIR_PATH)
# Create a client private key
openssl genrsa \
	-out client_private_key.pem 128 &&
openssl rsa \
	-pubout \
	-in client_private_key.pem \
	-out client_public_key.pem &&
for file in $files
do
	# Encrypt everything in DIR_PATH using 
	# The length is 3 characters for smaller rsa key size
	# thus a brute force can easily decrypt the files
	pswd=$(openssl rand -base64 3) &&
	openssl aes-128-cbc \
		-in $DIR_PATH'/'$file \
		-out $DIR_PATH'/'$file'.enc' \
		-pass pass:$pswd &&
	# Encrypt the AES key pairs using the client public key
	enc_pass=$(echo $pswd \
				| openssl rsautl \
				     -encrypt \
				     -pubin -inkey client_public_key.pem) &&
	touch $file.key &&
	echo "$enc_pass" >> $file.key
	rm ./test_files/$file 
done

# Encrypt the client private key with the server public key
# openssl rsautl \
# 		-encrypt \
# 		-inkey server_public_key.pem \
# 		-pubin \
# 		-in client_private_key.pem \
# 		-out client_private_key.pem.new &&

# rm client_private_key.pem
# mv client_private_key.pem.new client_private_key.pem