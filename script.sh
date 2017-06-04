DIR_PATH='./test_files'
files=$(ls $DIR_PATH)
touch decryptor.txt
for file in $files
do
	pswd=$(openssl rand -base64 7) &&
	openssl aes-256-cbc -in $DIR_PATH'/'$file -out $DIR_PATH'/'$file'.enc' -pass pass:$pswd
	echo "$file $pswd" >> decryptor.txt 
done