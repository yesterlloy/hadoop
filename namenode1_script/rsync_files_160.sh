#!/bin/bash


echo '从160复制文件..........................'
php_dir="/home/dopool/phpfile"
cron_dir="/home/hdfs/crontab"

#if [ -f $php_dir ];then
# echo "创建文件夹:"$php_dir"................................"
# mkdir -p $php_dir
#fi

#if [  -f $cron_dir ];then
# echo "创建文件夹:"$cron_dir"................................"
# mkdir -p $cron_dir
#echo 2
#fi


#scp -r dopool@10.0.11.160:/home/dopool/phpfile/* $php_dir
rsync -av -f '- *.log' -f '- *.txt' -f '- data' -f '- .svn' dopool@10.0.11.160:/home/dopool/phpfile/* $php_dir

#scp -r hdfs@10.0.11.160:/home/hdfs/crontab/* $cron_dir
rsync -av  hdfs@10.0.11.160:/home/hdfs/crontab/*.sh $cron_dir
echo '复制结束...................................'

echo '修改文件所属权............................'

chown -R dopool:dopool $php_dir
chmod -R +x $php_dir

chown -R hdfs:hdfs $cron_dir
chmod -R +x $cron_dir

echo '修改权限结束.............................'
