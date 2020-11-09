#!/bin/sh
source  ../bash_global
#配置监控脚本所在路径及脚本名称
SystemPath=$PWD
ScriptsName=RunAndMonitor.sh

ScriptsFullName=$SystemPath/$ScriptsName

##查看监控脚本是否在运行；若未运行，则启动监控脚本
proNum=`ps -ef |grep "$ScriptsName" |grep "/bin/bash" |wc -l`
if [ $proNum -eq 0 ];then
	nohup $ScriptsFullName >/dev/null 2>&1 &
	newProNum=`ps -ef |grep "$ScriptsName" |grep "/bin/bash" |wc -l`
	if [ $newProNum -eq 1 ];then
		echo "$ScriptsName startup OK !" 
	else
		echo "$ScriptsName startup fail !" 
	fi
else
	echo "$ScriptsName is running ..."
fi
   
RedisScriptsName=RedisMonitor.sh
RedisScriptsFullName=$SystemPath/$RedisScriptsName

##查看Redis-Server监控脚本是否在运行；若未运行，则启动监控脚本
proNum=`ps -ef |grep "$RedisScriptsName" | grep "/bin/bash" |wc -l`
if [ $proNum -eq 0 ];then
	nohup $RedisScriptsFullName >/dev/null 2>&1 &
	newProNum=`ps -ef |grep "$RedisScriptsName" | grep "/bin/bash" |wc -l`
	if [ $newProNum -eq 1 ];then
		echo "$RedisScriptsName startup OK !" 
	else
		echo "$RedisScriptsName startup fail !" 
	fi
else
	echo "$RedisScriptsName is running ..."
fi

CleanScriptsName=CleanOldFiles.sh
CleanScriptsFullName=$SystemPath/$CleanScriptsName

##查看清理过期日志文件的脚本是否在运行；若未运行，则启动监控脚本
proNum=`ps -ef |grep "$CleanScriptsName" | grep "/bin/bash" |wc -l`
if [ $proNum -eq 0 ];then
	nohup $CleanScriptsFullName >/dev/null 2>&1 &
	newProNum=`ps -ef |grep "$CleanScriptsName" | grep "/bin/bash" |wc -l`
	if [ $newProNum -eq 1 ];then
		echo "$CleanScriptsName startup OK !" 
	else
		echo "$CleanScriptsName startup fail !" 
	fi
else
	echo "$CleanScriptsName is running ..."
fi
