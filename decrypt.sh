DIR_PATH='./test_files'

# Map the files names to an array
key_files=$(ls *.key)

for key in $key_files
do
	openssl enc -in $key -out binary -d -a
	# dec_aes=$(openssl rsautl \
	# 	-decrypt \
	# 	-inkey client_private_key.pem \
	# 	-in binary)
	echo $binary
done