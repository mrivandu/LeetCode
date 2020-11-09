#!/bin/bash
##长期运行时用，隔断时间查看需监控的程序的运行状态，程序未运行或者起了多个进程，则重启程序。 
######################################## User Modify the Config #####################################
##Master服务,请设置对主服务器的免密登录
MasterServerIp=$THINKIT_GLOBAL_MASTER_IPADDR
##数据库相关
SHENG_FEN=$THINKIT_DB_KEY_WORD
DB_USER_PWD=./tools/db_user_pwd
MysqlServerIP=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $2}'`
MysqlDatabase=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $3}'`
MysqlUser=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $4}'`
MysqlPassword=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $5}'`
MysqlServerPort=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $6}'`
#####################################################################################################
##配置多长时间监控一次
step=3m

##引擎服务器标识
#SystemIPAddr=`ifconfig |grep inet |grep netmask |grep broadcast |head -1 |tail -1 | awk '{print $2}'`
SystemIPAddr=`hostname -i| awk '{print $1}'`
processorId=node_A

##redis服务相关
redisIp=$MasterServerIp
redisPort=30010
iscluster=$THINKIT_ISCLUSTER
#redis集群配置
redisAdd=$THINKIT_REDIS_ADD
#redisPassEncrypt=$THINKIT_REDIS_Encrypt
redisPass="$THINKIT_REDIS_PASS"
#passKeys=mysql_2018
redisTaskList=$THINKIT_REDIS_QUEUE
redisNotifyList=$THINKIT_REDIS_QUEUE_RES

#存放xml结果的目录后缀
xmlPathPostfix=_Xml

##角色区分服务端口, 即tomcat的http服务端口号：
roleServerPort=20101
#####################################################################################################

##配置系统根目录
SystemPath=$PWD

##配置日志文件
LogFile=${SystemPath}"/RunAndMonitor.log"

##配置需要监控的模块
KwsAndRecServer=true
ClusterAndSceneServer=true
InterruptionServer=true
XMLServer=true

OFFLINE_SYS_NUM=1
PROCESSOR_OF_CORE=2
THREAD_CORE_NUM=`cat /proc/cpuinfo | grep processor | wc -l`
BEISHU=$[$OFFLINE_SYS_NUM * $PROCESSOR_OF_CORE]
##配置识别服务相关
KwsAndRecServerProName="offline_customer_server_test_dnnvad"
KwsAndRecServerPath=${SystemPath}"/TBNR_release_time/bin"
KwsAndRecServerProScript=./run.sh
KwsAndRecServerNThread=$[($THREAD_CORE_NUM+$BEISHU-1)/$BEISHU]

##配置场景分割相关
ClusterAndSceneServerProName="Cluster_Scene_server_test"
ClusterAndSceneServerPath=${SystemPath}"/ClusterSceneServer"
ClusterAndSceneServerProScript=./run.sh
ClusterAndSceneServerNThread=3
##根据以上配置自动修改场景分割配置文件
sed -i "s/^\(\s*roleServerPort=\).*/\1$roleServerPort/"    $ClusterAndSceneServerPath\/$ClusterAndSceneServerProScript

##配置叠音相关
InterruptionServerProName="DetectOverlapPro"
InterruptionServerPath=${SystemPath}"/DetectOverlap"
InterruptionServerProScript=./run.sh
if [ $KwsAndRecServerNThread -gt 1 ]; then
	InterruptionServerNThread=$[($KwsAndRecServerNThread+4)/5]
else
	InterruptionServerNThread=1
fi

##配置xml服务相关
XMLServerProName="XMLServer"
XMLServerPath=${SystemPath}"/xml_server"
XMLServerProScript=./run.sh
XMLServerNThread=1

##配置总控端相关
ClientProName="custom_client_multiserver"
ClientPath=${SystemPath}"/Offline_System_Client"
ClientProScript=./run.sh
ClientConfig=${SystemPath}"/Offline_System_Client/cfg.ini"
CtrlTaskShell=${SystemPath}"/Offline_System_Client/ctrlTask.sh"

## Handle MysqlPassword with special word;
HandleMysqlPassword() {
    LINE_NUM=`grep -rn "MysqlPassword=" Offline_System_Client/cfg.ini | cut -d ":" -f 1`
    LINE_NUM_PRE=$[($LINE_NUM-1)]
    LINE_NUM_POST=$[($LINE_NUM+1)]
    sed  -n '1,'${LINE_NUM_PRE}'p'  $ClientConfig          >   ${ClientConfig}.tmp
    echo "MysqlPassword=$MysqlPassword"                    >>  ${ClientConfig}.tmp
    sed  -n ''${LINE_NUM_POST}',$p'  $ClientConfig         >>  ${ClientConfig}.tmp
    cp -af ${ClientConfig}.tmp ${ClientConfig}
}

##根据以上配置自动修改总控端配置文件
sed -i "s/^\(\s*MysqlServerIP=\).*/\1$MysqlServerIP/"                  $ClientConfig
sed -i "s/^\(\s*MysqlServerPort=\).*/\1$MysqlServerPort/"              $ClientConfig
sed -i "s/^\(\s*MysqlDatabase=\).*/\1$MysqlDatabase/"                  $ClientConfig
sed -i "s/^\(\s*MysqlUser=\).*/\1$MysqlUser/"                          $ClientConfig
HandleMysqlPassword
sed -i "s/^\(\s*redisCluster=\).*/\1$iscluster/"                       $ClientConfig
sed -i "s/^\(\s*redisIp=\).*/\1$redisIp/"                              $ClientConfig
sed -i "s/^\(\s*redisPort=\).*/\1$redisPort/"                          $ClientConfig
sed -i "s/^\(\s*redisAdd=\).*/\1$redisAdd/"                            $ClientConfig
sed -i "s/^\(\s*redisPass=\).*/\1$redisPass/"                          $ClientConfig
sed -i "s/^\(\s*redisTaskList=\).*/\1$redisTaskList/"                  $ClientConfig
sed -i "s/^\(\s*redisNotifyList=\).*/\1$redisNotifyList/"              $ClientConfig
sed -i "s/^\(\s*xmlPathPostfix=\).*/\1$xmlPathPostfix/"                $ClientConfig
sed -i "s/^\(\s*maxHandleThread=\).*/\1$KwsAndRecServerNThread/"       $ClientConfig
sed -i "s/^\(\s*processorId=\).*/\1$SystemIPAddr:$processorId/"        $ClientConfig
sed -i "s/^\(\s*KwsAndRecServer=\).*/\1$KwsAndRecServer/"              $ClientConfig
sed -i "s/^\(\s*ClusterAndSceneServer=\).*/\1$ClusterAndSceneServer/"  $ClientConfig
sed -i "s/^\(\s*InterruptionServer=\).*/\1$InterruptionServer/"        $ClientConfig
sed -i "s/^\(\s*XMLServer=\).*/\1$XMLServer/"                          $ClientConfig
sed -i "s/^\(\s*SERIPADDR=\).*/\1$MasterServerIp/"                     $CtrlTaskShell
sed -i "s/^\(\s*OWNIPADDR=\).*/\1$SystemIPAddr/"                       $CtrlTaskShell
	
##查看相同进程名的起了几个进程
checkprocess() {  
     #echo "entering chechprocess()"  
     #echo "parameter is :"  $1
       if [ "$1" = "" ];    then      
            return 1  
       fi    
       declare -i process_num=0  
      # echo "ps result is :" $process_num  
       process_num=`ps -ef |grep "$1" |grep -v "grep" |wc -l`  
      # echo "process_num :"  $process_num    
       return $process_num  
   }
 

##启动服务端进程
restartServer(){
	#echo "patameter is :" $1 $2 $3 $4 $5 $6
	#echo "patameter is :" $1 $2 $3 $4 $5 $6>>$LogFile
	serverName=$1;isDo=$2;proName=$3;proScript=$4;nThread=$5;path=$6
	if [ $isDo = "true" ];then
		proNum=`ps -ef |grep "$proName" |grep -v "grep" |wc -l`
		#echo "$proName: proNum=" $proNum
		#echo "$proName: proNum=" $proNum  >>$LogFile
		if [ $proNum -eq 0 ];then
			#echo "$serverName: $proName is not running, will start soon" 
			#echo "$serverName: $proName is not running, will start soon" >>$LogFile
			cd $path
			#echo "Current path: "$(pwd) 
			#echo "Current path: "$(pwd)  >>$LogFile
			nohup $proScript $nThread >/dev/null 2>&1 &
                else
			echo "$serverName: $proNum $proName running,will restart soon !" 
                        echo "$serverName: $proNum $proName running,will restart soon !" >>$LogFile
			killall $proName
			sleep 30s
			#echo "Wait for killing server..."   
			#echo "Wait for killing server..."   >>$LogFile
			cd $path
			#echo "Current path: "$(pwd)
			#echo "Current path: "$(pwd)  >>$LogFile
			nohup $proScript $nThread >/dev/null 2>&1 &
        	fi

	fi
} 

##启动总控端进程
restartClient(){
        #echo "patameter is :" $1 $2 $3
	#echo "patameter is :" $1 $2 $3 >>$LogFile
        proName=$1;proScript=$2;path=$3
        proNum=`ps -ef |grep "$proName" |grep -v "grep" |wc -l`
        #echo "$proName: proNum=" $proNum
	#echo "$proName: proNum=" $proNum >>$LogFile
        if [ $proNum -eq 0 ];then
		#echo "Client: $proName is not running, will start soon"
		#echo "Client: $proName is not running, will start soon">>$LogFile
		cd $path
		#echo "Current path: "$(pwd)  
		#echo "Current path: "$(pwd)  >>$LogFile
		nohup $proScript >/dev/null 2>&1 &
	else
		echo "Client: $proNum $proName running, will restart soon!"
		echo "Client: $proNum $proName running, will restart soon!">>$LogFile
		killall $proName
		sleep 30s
		#echo "Wait for killing client..."   
		#echo "Wait for killing client..."   >>$LogFile
		cd $path
		#echo "Current path: "$(pwd)  
		#echo "Current path: "$(pwd)  >>$LogFile
		nohup $proScript >/dev/null 2>&1 &
        fi
}

##检查服务端进程是否在运行
isServerOn(){
	isDo=$1;proName=$2
	if [ $isDo = "true" ];then
		proNum=`ps -ef |grep "$proName" |grep -v "grep" |wc -l`
		if [ $proNum -eq 1 ];then
			echo "$proName is running" 
			echo "$proName is running"  >>$LogFile
		elif [ $proNum -eq 0 ];then
			echo "Error: restart $proName failed!"
			echo "Error: restart $proName failed!"  >>$LogFile
		fi
	fi
}

##检查总控端进程是否在运行
isClientOn(){
	proName=$1
	proNum=`ps -ef |grep "$proName" |grep -v "grep" |wc -l`
	if [ $proNum -eq 1 ];then
		echo "$proName is running" 
		echo "$proName is running"  >>$LogFile
	elif [ $proNum -eq 0 ];then
		echo "Error: restart $proName failed!"
		echo "Error: restart $proName failed!"  >>$LogFile
	fi
}

##重启所有服务端和总控端进程
restartAll(){
	#date >> $LogFile
	#echo "restartAll()  start"
	#echo "restartAll()  start">>$LogFile
	
	##关闭所有服务端和总控端进程
	echo "restart all server and client..."  
	echo "restart all server and client..."  >>$LogFile

	killall $KwsAndRecServerProName
	killall $ClusterAndSceneServerProName
	killall $InterruptionServerProName
	killall $XMLServerProName
	killall $ClientProName

	##等待占用的端口号被释放
	#echo "Wait for killing all server and client..."   
	#echo "Wait for killing all server and client..."   >>$LogFile
	sleep 10s


	##重启各服务端
	restartServer KwsAndRecServer $KwsAndRecServer $KwsAndRecServerProName $KwsAndRecServerProScript  $KwsAndRecServerNThread $KwsAndRecServerPath
	restartServer ClusterAndSceneServer $ClusterAndSceneServer $ClusterAndSceneServerProName $ClusterAndSceneServerProScript  $ClusterAndSceneServerNThread $ClusterAndSceneServerPath
	restartServer InterruptionServer  $InterruptionServer $InterruptionServerProName $InterruptionServerProScript  $InterruptionServerNThread $InterruptionServerPath
	restartServer XMLServer  $XMLServer $XMLServerProName $XMLServerProScript  $XMLServerNThread $XMLServerPath

	##等待各服务端初始化完成
	echo "Wait for server initial..."  
	echo "Wait for server initial..."   >>$LogFile
	sleep 1m

	##检查各服务端是否在运行 
	isServerOn $KwsAndRecServer $KwsAndRecServerProName
	isServerOn $ClusterAndSceneServer $ClusterAndSceneServerProName
	isServerOn $InterruptionServer $InterruptionServerProName
	isServerOn $XMLServer $XMLServerProName

	##重启总控端
	restartClient $ClientProName $ClientProScript $ClientPath

	##等待总控端初始化完成
	echo "Wait for client initial..."  
	echo "Wait for client initial..."   >>$LogFile
	sleep 5s

	##检查总控端是否在运行
	isClientOn $ClientProName
	
	#date >> $LogFile
	#echo "restartAll()  end"
	#echo "restartAll()  end">>$LogFile
}

##监控进程是否在运行，若未运行或者运行多个同名进程，则调用restartAll重启全部服务端和总控端
monitor(){
	proName=$1
	proNum=`ps -ef |grep "$proName" |grep -v "grep" |wc -l`
	#echo "$proName: proNum=" $proNum
	if [ $proNum -ne 1 ];then
		echo `date`
		date >>$LogFile
	
		##程序未运行或者开启多个进程，则杀死所有进程，之后重启
		echo "$proNum $proName running,will restart soon !" 
		echo "$proNum $proName running,will restart soon !" >>$LogFile
		
		##重启所有服务端和总控端	
		restartAll
		
		echo `date`
		date >>$LogFile
		echo "..."
		echo >>$LogFile
	fi
	
}

##############################################################################################
##先杀掉所有识别服务相关进程
echo `date`
date >>$LogFile
echo "RunAndMonitor.sh begin... "  >>$LogFile
echo "Shutdown all Server And Client "  >>$LogFile

killall "offline_customer_server_test_dnnvad"
#echo "kill offline_customer_server_test_dnnvad ok !" 
#echo "kill offline_customer_server_test_dnnvad ok !"  >>$LogFile

killall "Cluster_Scene_server_test"
#echo "kill Cluster_Scene_server_test ok !" 
#echo "kill Cluster_Scene_server_test ok !"  >>$LogFile

killall "DetectOverlapPro"
#echo "kill DetectOverlapPro ok !" 
#echo "kill DetectOverlapPro ok !"  >>$LogFile

killall "XMLServer"
#echo "kill XMLServer ok !" 
#echo "kill XMLServer ok !"  >>$LogFile

killall "custom_client_multiserver"
#echo "kill custom_client_multiserver ok !" 
#echo "kill custom_client_multiserver ok !"  >>$LogFile

#echo >>$LogFile


##间隔$step时间循环监控进程状态，若有进程未在运行，则重启所有语音识别相关进程
while [ 1 ] ; do 

monitor offline_customer_server_test_dnnvad
monitor Cluster_Scene_server_test
monitor DetectOverlapPro
monitor XMLServer
monitor custom_client_multiserver

sleep $step

done  
