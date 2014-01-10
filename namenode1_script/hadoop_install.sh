#!/bin/bash

function hadoop_install(){

#echo '添加本地源........................'
#echo "deb file:/var/www sid main" >> /etc/apt/sources.list

echo '安装jdk.................'
sudo apt-get install -y oracle-j2sdk1.6 --force-yes
echo "export JAVA_HOME=/usr/lib/jvm/j2sdk1.6-oracle" >> /etc/profile
source /etc/profile

echo '安装python2.6.6...................'
#wget http://www.python.org/ftp/python/2.6.6/Python-2.6.6.tgz
wget http://10.0.11.160/debian/Python-2.6.6.tgz
tar xfz Python-2.6.6.tgz
cd Python-2.6.6
./configure
make
make install

cd ..

echo '安装mysql.........................'
apt-get install -y mysql-server mysql-client --force-yes

echo '安装hadoop............................................'
apt-get install -y cloudera-manager-agent cloudera-manager-daemons cloudera-manager-server flume-ng oozie oozie-client pig sqoop hadoop hadoop-0.20-mapreduce hadoop-client hadoop-hdfs hadoop-hdfs-fuse hadoop-httpfs hadoop-mapreduce hadoop-yarn hbase hive --force-yes

#cloudera-manager-server
#hadoop-hdfs-fuse
#apt-get install -y hue hue-about hue-beeswax hue-common hue-filebrowser hue-help hue-jobbrowser hue-jobsub hue-oozie hue-plugins hue-proxy hue-shell hue-useradmin


#下载安装包
#wget http://archive.cloudera.com/cm4/installer/latest/cloudera-manager-installer.bin
wget http://10.0.11.160/debian/cloudera-manager-installer.bin
chmod +x cloudera-manager-installer.bin

#echo '安装cloudera-manager...................................'
#chmod u+x cloudera-manager-installer.bin

sudo ./cloudera-manager-installer.bin


echo '在hive的lib目录安装mysql JDBC Connector'
wget http://10.0.11.160/debian/mysql-connector-java-5.1.22-bin.jar
cp mysql-connector-java-5.1.22-bin.jar /usr/lib/hive/lib/

}



function hadoop_uninstall(){
#卸载
#usr/share/cmf/uninstall-cloudera-manager.sh

rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera*
ssh 10.0.11.99 rm -Rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera*

#usr/sbin/service cloudera-scm-agent hard_stop
ssh 10.0.11.99 /usr/sbin/service cloudera-scm-agent hard_stop



apt-get remove -y cloudera-manager-agent
apt-get remove -y cloudera-manager-daemons
apt-get remove -y flume-ng
apt-get remove -y hadoop
apt-get remove -y hadoop-0.20-mapreduce
apt-get remove -y hadoop-client
apt-get remove -y hadoop-hdfs
apt-get remove -y hadoop-hdfs-fuse
apt-get remove -y hadoop-httpfs
apt-get remove -y hadoop-mapreduce
apt-get remove -y hadoop-yarn
apt-get remove -y hbase
apt-get remove -y hive
apt-get remove -y hue
apt-get remove -y hue-about
apt-get remove -y hue-beeswax
apt-get remove -y hue-common
apt-get remove -y hue-filebrowser
apt-get remove -y hue-help
apt-get remove -y hue-jobbrowser
apt-get remove -y hue-jobsub
apt-get remove -y hue-oozie
apt-get remove -y hue-plugins
apt-get remove -y hue-proxy
apt-get remove -y hue-shell
apt-get remove -y hue-useradmin
apt-get remove -y oozie
apt-get remove -y oozie-client
apt-get remove -y pig
apt-get remove -y sqoop
}

