#!/bin/bash
#===========================================
#安装程序
#自动化安装,本程序只参在超级用户下面安装,否则会安装失败
#===========================================
#@author:sunchao
#@version:1.0
#@data:2014-1-3
#
#
#引入模块
source ./install_common/common_function.sh    #引入常用函数模块
source ./crontab_script/crontab_function.sh   #引入crontab函数模块
source ./mysql_script/mysql_function.sh       #引入mysql函数模块
source ./php_script/php_function.sh           #引入php函数模块
#查看是否是超级管理员
current_user=`whoami`
if [ "${current_user}" != "root" ] ; then
    echo "请在root管理员帐户下安装"
    return 0
fi
#查看当前网络是否能连接
current_telnet=`ping -c 2 www.dopool.com 2>&1 | grep -v 'unknown host' | grep 'ttl'`
if [ ! -n "$current_telnet" ] ; then
    echo "网络不通,请检查网络"
    return 0
fi
echo "================安装开始================"
#site 1
#安装MySQL步骤
echo "第一步:安装MySQL"
echo "========================================"
#从MySQL服务器源安装
echo "1)检查MySQL服务"
stats=$(checkMySQLServer)
if [ $stats -eq 200 ] ; then
    echo "MySQL已经安装"
else
    echo "安装MySQL应用"
    installMySQLFromSource
    stats=$?
    if [ $stats -eq 0 ] ; then
        echo "安装MySQL出错,请重新安装"
    fi
    if [ $stats -eq 1 ] ; then
        echo "安装MySQL成功"
    fi
fi
echo "2)启动MySQL服务"
startMySQL
stats=$?
if [ $stats -eq 0 ] ; then
    echo "没有mysql服务"
else
    echo "启动成功"
fi

#site 2
#安装PHP步骤
echo "第二步:安装PHP"
echo "========================================"
echo "1)检查PHP是否已经安装,如果没有装安装"
checkPHP
stats=$?
if [ $stats -eq 1 ] ; then
    echo "PHP已经安装"
else
    installPHPFromSource
fi
echo "2)启动php5-fpm服务"
startPHPServer
stats=$?
if [ $stats -eq 0 ] ; then
    echo "php5-fpm服务不存在"
else
    echo "php5-fpm服务启动成功"
fi
#site 3
#安装Nginx步骤
echo "第三步:安装Nginx"
echo "========================================"
echo "启动Nginx服务"
if [ ! -f "/etc/init.d/nginx" ] ; then
     echo "Nginx服务不存在"
else
     `/etc/init.d/nginx start >/dev/null 2>&1`
     echo "Nginx服务启动"
fi


#site 4
#安装crontab步骤
echo "第四步:安装crontab"
echo "========================================"
#如果是多个用户,请先确认每个用户都已经存在,要不在后面处理过程中会处错误
#
#单用户只判断dopool用户是否存在
user=dopool
echo "1)检查用户${user}是否存在"
checkUser $user
if [ $? -eq 0 ] ; then
   #用户不存在
   echo "${user}用户不存在,请创建用户"
   return 0
else
   echo "${user}用户存在"
fi
#备份当前用户的crontab文件
echo "2)备份${user}的crontab文件"
backup_crontab $user
stats=$?
if [ $stats -eq 0 ] ; then
   #传参失败,备份失败
   echo "${user}用户的crontab文件,没有参数"
   return 0
fi
if [ $stats -eq 1 ] ; then
   #文件不存在,不用备份
   echo "${user}用户的crontab文件,文件不存在,不用备份"
fi
if [ $stats -eq 2 ] ; then
   #文件存在,备份成功
   echo "${user}用户的crontab文件,备份成功"
fi

#重写当前用户的crontab文件
echo "3)重写${user}的crontab文件"
up_crontab $user
stats=$?
if [ $stats -eq 0 ] ; then
    #传参失败,重写失败
    echo "${user}用户的crontab文件,没有参数"
fi
if [ $stats -eq 1 ]; then
    #文件存在,写入成功
    echo "${user}用户的crontab文件,重写成功"
fi
#在后面的操作中,如果有操作失败，请回滚crontab文件
#site 5
#复制文件
echo "第五步:复制文件"
echo "========================================"
#复制脚本文件
#复制 makech_like.php
sourceFile="./files/makech_like.php"
tagetFile="/home/dopool/phpfile/retime-mysql/makech_like.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
sourceFile="./files/a3_retime_channelfiveday.php"
tagetFile="/home/dopool/phpfile/retime-mysql/a3_retime_channelfiveday.php"
copyFile $sourceFile $tagetFile


if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
sourceFile="./files/a3_memory_del.php"
tagetFile="/home/dopool/phpfile/retime-mysql/a3_memory_del.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
sourceFile="./files/a3_retime_fiveday.php"
tagetFile="/home/dopool/phpfile/retime-mysql/a3_retime_fiveday.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
sourceFile="./files/week_epg.php"
tagetFile="/home/dopool/phpfile/php-epg/week_epg.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
sourceFile="./files/epgupdate_main.php"
tagetFile="/home/dopool/phpfile/php-epg/epgupdate_main.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi

sourceFile="./files/carousels_cmsv2.php"
tagetFile="/home/dopool/phpfile/carousels/carousels_cmsv2.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
sourceFile="./files/carousels_cmsv4.php"
tagetFile="/home/dopool/phpfile/carousels/carousels_cmsv4.php"
copyFile $sourceFile $tagetFile
if [ $? -eq 1 ] ; then
    echo "复制 ${tagetFile} 成功"
else
    echo "复制 ${tagetFile} 失败"
fi
echo "================安装结束================"






















