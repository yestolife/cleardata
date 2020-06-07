#!bin/bash
#generate test files

for i in $(seq 10)
do 
file_name=$(date +"%Y%m%d_%H%M%S")
dd if=/dev/zero of="test_$file_name" bs=10M count=180
sleep 1m	
done
