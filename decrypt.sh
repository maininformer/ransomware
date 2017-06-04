DIR_PATH='./test_files'

# Map the files names to an array
key_files=$(ls *.key)

for key in $key_files
do
	dec_aes=$(cat $key \
			| openssl rsautl \
				-decrypt \
				-inkey client_private_key.pem)
	echo $dec_aes
done