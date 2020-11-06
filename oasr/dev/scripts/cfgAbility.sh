#!/bin/sh
########################################## User-Cfg-Space #################################################
### JDBC 
#SHENG_FEN=`grep "SHENG_FEN" RunAndMonitor.sh | grep -v "sed" | head -1 | cut -d'=' -f 2`
SHENG_FEN=$THINKIT_DB_KEY_WORD
DB_USER_PWD=`grep "DB_USER_PWD" RunAndMonitor.sh | grep -v "sed" | head -1 | cut -d'=' -f 2`
JDBC_IP=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $2}'`
JDBC_DB=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $3}'`
JDBC_USER=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $4}'`
JDBC_PWD=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $5}'`
JDBC_PORT=`grep $SHENG_FEN $DB_USER_PWD | awk '{print $6}'`
###########################################################################################################
## Log4j
LOG4J_DIR=$HOME/abilitylog
LOG4J_LOG=jsonrpc.log
ROOT_LOGGER="error, MyConsole, MyRfile1"

## Redis
#REDIS_SERVER=`ifconfig |grep inet |grep netmask |grep broadcast |head -1 |tail -1 | awk '{print $2}'`
REDIS_SERVER=`hostname -i| awk '{print $1}'`
REDIS_PORT=30010
ISCLUSTER=$THINKIT_ISCLUSTER
REDIS_ADD=$THINKIT_REDIS_ADD
REDIS_PASS=$THINKIT_REDIS_PASS
PASS_KEYS=$THINKIT_REDIS_PASS_KEYS
REDIS_QUEUE=$THINKIT_REDIS_QUEUE
REDIS_TMP_VIOCE=$HOME/tempvoice
###########################################################################################################
JDBCP_CFG=~/local/tomcat/apache-tomcat-8.5.5/webapps/ability/WEB-INF/classes/jdbc.properties
LOG4J_CFG=~/local/tomcat/apache-tomcat-8.5.5/webapps/ability/WEB-INF/classes/log4j.properties
REDIS_CFG=~/local/tomcat/apache-tomcat-8.5.5/webapps/ability/WEB-INF/classes/redis.properties
###########################################################################################################
#### Log4j
mkdir -p $LOG4J_DIR
sed -i "s%^\(\s*log4j.appender.MyRfile1.File=\).*%\1$LOG4J_DIR\/$LOG4J_LOG%"    $LOG4J_CFG
sed -i "s%^\(\s*log4j.rootLogger=\).*%\1$ROOT_LOGGER%"                          $LOG4J_CFG
echo ============ $LOG4J_CFG ============
cat  $LOG4J_CFG
#### Redis
echo "isCluster=$ISCLUSTER"                                             >   $REDIS_CFG
echo "redisAdd=$REDIS_ADD"                                              >>  $REDIS_CFG
echo "redis.server=$REDIS_SERVER"                                       >>  $REDIS_CFG
echo "redis.port=$REDIS_PORT"                                           >>  $REDIS_CFG
echo "redis.queue=$REDIS_QUEUE"                                         >>  $REDIS_CFG
echo "connectionTimeout=2000"                                           >>  $REDIS_CFG
echo "soTimeout=2000"                                                   >>  $REDIS_CFG
echo "maxAttempts=6"                                                    >>  $REDIS_CFG
echo "redisPassword=$REDIS_PASS"                                        >>  $REDIS_CFG
mkdir -p $REDIS_TMP_VIOCE
echo "voiceTempPath = $REDIS_TMP_VIOCE"                                 >>  $REDIS_CFG
echo "grsSleepTime=1000"                                 		>>  $REDIS_CFG
echo "initialCapacity=1000"                                 		>>  $REDIS_CFG
echo "maximumSize=1000"                                 		>>  $REDIS_CFG
echo ============ $REDIS_CFG ============
cat  $REDIS_CFG
##==========================================================================================
#### JDBC
echo "driver=com.mysql.jdbc.Driver"                                     >   $JDBCP_CFG
echo "url=jdbc:mysql://$JDBC_IP:$JDBC_PORT/$JDBC_DB?&characterEncoding=UTF8" >>  $JDBCP_CFG
echo "username=$JDBC_USER"                                              >>  $JDBCP_CFG
echo "password=$JDBC_PWD"                                               >>  $JDBCP_CFG
echo ============ $JDBCP_CFG ============
cat  $JDBCP_CFG
##==========================================================================================
###########################################################################################################
REDIS_CONF_FILE=~/local/redis/redis-3.2.0/redis.conf
sed -i "s/^\(\s*bind \).*/\1$REDIS_SERVER/"    $REDIS_CONF_FILE
grep "bind "                                   $REDIS_CONF_FILE
