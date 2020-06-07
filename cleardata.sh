#!bin/bash
#clear data

path_clear="/home/andy/test"
threshold_value=20

usage=`df -lh $path_clear | awk -F '[ %]+' '$5 ~ /[0-9]/ {print $5}'`
if [ $usage -gt $threshold_value ] 
then
	echo "At $(date "+%Y%m%d-%H%M%S") usage is $usage %,and start clearing" >> $path_clear/monitor.log
	find $path_clear -name 'test_*' -and -mmin +2 | xargs rm -rf
	usage=`df -lh $path_clear | awk -F '[ %]+' '$5 ~ /[0-9]/ {print $5}'`
	echo "cleared data and the useage is $usage %" >> $path_clear/monitor.log 
fi
