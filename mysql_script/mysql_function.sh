#!/bin/bash
#====================================================
#安装程序
#安装MySQL
#====================================================
#@author:sunchao
#@version:0.1
#@date:2013-12-19
#
#
#安装MySQL从服务器源
function installMySQLFromSource()
{
  installPath=`pwd`
  cd /
  echo "正在删除/var/lib/mysql/目录下的文件"
  sudo rm /var/lib/mysql/ -R
  echo "正在删除/etc/mysql/目录下的文件"
  sudo rm /etc/mysql/ -R
  echo "正在删除MySQL依赖包"
  sudo apt-get autoremove mysql* --purge
  echo "正在删除MySQL包管理"
  sudo apt-get remove apparmor
  echo "正在安装MySQL......................"
  sudo apt-get install mysql-server -y
  cd $installPath
  if [ -f "/etc/init.d/mysql" ] ; then
      return 1
  else
      return 0
  fi
}
#安装MySQL从RPM包里安装
function installMySQLFromRpm()
{
   #todo
   return 0
}

#查看是否启动MySQL服务
function checkMySQLServer()
{
   port=3306
   if [ $1 ] ; then
       port=$1
   fi
   cmdcheck=`lsof -i:${port} &>/dev/null`
   port="$?"
   pidcheck=`ps aux|grep mysqld|grep -v grep`
   pid="$?"
   if [ "$port" -eq "0" -a "$pid" -eq 0 ] ; then
      echo 200
   else
      echo 500
   fi
}
#启动MySQL
function startMySQL()
{
    if [ ! -f "/etc/init.d/mysql" ] ; then
        return 0
    fi
    `/etc/init.d/mysql start`
    return 1
}
#停止Mysql
function stopMySQL()
{
    if [ ! -f "/etc/init.d/mysql" ] ; then
        return 0
    fi
    `/etc/init.d/mysql stop`
    return 1
}

#从新启动MySQL
function restartMySQL()
{
    if [ ! -f "/etc/init.d/mysql" ] ; then
        return 0
    fi
    `/etc/init.d/mysql restart`
    return 1
}
#创建数据库
function createMySQLDBAndTable()
{
    db="data"
    table="table.sql"
    if [ $1 ] ; then
        db=$1
    fi
    echo "如果${db}数据库不存在，则创建数据库"
    `mysql -u root -p -e "create database if not exists ${db};set names utf8;SOURCE ${table}"`
}





