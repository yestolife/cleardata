时常遇到服务器磁盘出现高占用，然后手动删除无关文件的情况。写一个自动清理的脚本，可以节省运维时间。

测试中需要生成文件的sh脚本参考[这里](https://www.cnblogs.com/zl1991/p/7230490.html)，检测磁盘并清理的sh脚本参考[这里](https://www.cnblogs.com/grimm/p/6738527.html)。定时任务配置参考[这里](https://blog.csdn.net/qq_39889272/article/details/81215173)。

具体脚本如下：

1.模拟生成文件脚本

```
#!bin/bash
#generate test files
#循环10次
for i in $(seq 10)
do 
#以时间命名文件
file_name=$(date +"%Y%m%d_%H%M%S")
#产生10M*180（1.8G）大小的文件，因为磁盘可用18G，每次占用10%
dd if=/dev/zero of="test_$file_name" bs=10M count=180
#等待1分钟
sleep 1m	
done
```

2.检查磁盘并清理脚本

```
#!bin/bash
#clear data
#待清除的目录设置
path_clear="/home/andy/test"
#磁盘占用比率设置，超过后开始清理
threshold_value=20
#读取当前磁盘占用比率
usage=`df -lh $path_clear | awk -F '[ %]+' '$5 ~ /[0-9]/ {print $5}'`
#如果超过阈值就执行清理
if [ $usage -gt $threshold_value ] 
then
	#清理前写一条日志，记录时间和当前磁盘占用率
	echo "At $(date "+%Y%m%d-%H%M%S") usage is $usage %,and start clearing" >> $path_clear/monitor.log
	#找到2分钟以前的文件并删除
	find $path_clear -name 'test_*' -and -mmin +2 | xargs rm -rf
	#重新计算磁盘占用比率
	usage=`df -lh $path_clear | awk -F '[ %]+' '$5 ~ /[0-9]/ {print $5}'`
	#清理完后写入日志记录
	echo "cleared data and the useage is $usage %" >> $path_clear/monitor.log 
fi
```

3.定时任务配置

`*/2 * * * * bash /home/andy/test/cleardata.sh`每2分钟执行一次`cleardata.sh`脚本

