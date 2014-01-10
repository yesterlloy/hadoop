#!/bin/bash
#
#====================================================
#安装程序
#用于安装crontab
#====================================================
#@author:sunchao<sunchao@starschina.com>
#@version:0.1
#@date:2017-12-19
#
#
#定义临时文件存放路径
crontab_tmp="./tmp/"
#定义crontab路径
crontab_url="/var/spool/cron/crontabs/"
#备份crontab
#传送入参$1为要备份的用户名
function backup_crontab()
{
    if [ ! -n "$1" ] ; then
        return 0
    fi
    user=$1
    user_crontab_url="${crontab_url}${user}"
    if [ ! -f "${user_crontab_url}" ] ; then
        return 1
    fi
    if [ -f "${crontab_tmp}${user}" ] ; then
        rm "${crontab_tmp}${user}"
    fi
    cp $user_crontab_url ${crontab_tmp}${user}
    return 2
}

#恢复备份crontab
function down_crontab()
{
    if [ ! -n "$1" ] ; then
        return 0
    fi
    user=$1
    user_crontab_url="${crontab_user}${user}"
    if [ ! -f "${crontab_tmp}${user}" ] ; then
        return 1
    else
        cp ${crontab_tmp}${user} $user_crontab_url
        return 2
    fi
}
#重写crontab
#传入参数$1为要追加的用户名
function up_crontab()
{
    if [ ! -n "$1" ] ; then
        return 0
    fi
    user=$1
    crontab_file_name="./crontab_script/shell_crontab_${user}.txt"
    if [ -n "$2" ] ; then
        crontab_file_name=$2
    fi
    #判断是否有crontab文件
    user_crontab_url="${crontab_url}${user}"
    if [ ! -f "${user_crontab_url}" ] ; then
         cp ${crontab_tmp}"crontab" $user_crontab_url
    fi
    cat $crontab_file_name >> $user_crontab_url
    return 1
}
