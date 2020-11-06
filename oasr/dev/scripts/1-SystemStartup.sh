####功能：开启所在服务器上的分布式离线客服系统相关程序
####注意：1.所在服务器上没有部署的模块相应的命令行请注释掉
########  2.请根据实际部署位置配置tomcatBinDir和sysDir变量。
source ./bash_global
tomcatBinDir=$HOME/local/tomcat/apache-tomcat-8.5.5/bin
sysDir=$(cd `dirname $0`; pwd)

echo "Input Param Is [$1]"
if [ "$1" = "install" ]; then
    cd $sysDir/System_Offline_Server/tools/AutomaticInstall
    ./run.sh                            ## install all the pkg
    cd $tomcatBinDir; ./startup.sh; sleep 10s; ./shutdown.sh 
    cd $sysDir/System_Offline_Server
    ./cfgAbility.sh                     ## 配置tomcat
else
cd $sysDir/System_Offline_Server
./cfgAbility.sh
###开启tomcat服务
cd $tomcatBinDir
./startup.sh    
###开启转写服务
cd $sysDir/System_Offline_Server 
./startup.sh    
fi
