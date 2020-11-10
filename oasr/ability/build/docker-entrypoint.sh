#!/bin/bash
# Author:DURUIHONG
# Build time: 2020-07-14
# E-mail:duruihong@cmos.chinamobile.com

set -eux
mkdir -p /apache-tomcat-8.5.5/webapps/WEB-INF/classes
cat>/apache-tomcat-8.5.5/webapps/ability/WEB-INF/classes/redis.properties<<-EOF
isCluster=${ISCLUSTER}
redisAdd=${REDISADD}
redis.server=${REDIS_SERVER}
redis.port=${REDIS_PORT}
redis.queue=${REDIS_QUEUE}
connectionTimeout=${CONNECTIONTIMEOUT}
soTimeout=${SOTIMEOUT}
maxAttempts=${MAXATTEMPTS}
redisPassword=${REDISPASSWORD}
voiceTempPath =${VOICETEMPPATH }
grsSleepTime=${GRSSLEEPTIME}
initialCapacity=${INITIALCAPACITY}
maximumSize=${MAXIMUMSIZE}
EOF

cat>/apache-tomcat-8.5.5/webapps/ability/WEB-INF/classes/jdbc.properties<<-EOF
driver=${DRIVER}
url=${URL}
username=${USERNAME}
password=${PASSWORD}
EOF

cat>/apache-tomcat-8.5.5/webapps/ability/WEB-INF/classes/log4j.properties<<-EOF
# define log level and output
log4j.rootLogger=${LOG4J_ROOTLOGGER}

########################
# Console Appender 
########################
log4j.appender.MyConsole=${LOG4J_APPENDER_MYCONSOLE}
log4j.appender.MyConsole.Threshold=${LOG4J_APPENDER_MYCONSOLE_THRESHOLD}
log4j.appender.MyConsole.Target=${LOG4J_APPENDER_MYCONSOLE_TARGET}
log4j.appender.MyConsole.layout=${LOG4J_APPENDER_MYCONSOLE_LAYOUT}
# %d time
# %r ms
# %t thread name
# %p pro DEBUG/INFO/ERROR
# %c package class name
# %l position
# %m log(message)
# %n \n
log4j.appender.MyConsole.layout.ConversionPattern=${LOG4J_APPENDER_MYCONSOLE_LAYOUT_CONVERSIONPATTERN}


######################## 
# Rolling File (everyday a file)
######################## 
log4j.appender.MyRfile1=${LOG4J_APPENDER_MYRFILE1}
log4j.appender.MyRfile1.Threshold=${LOG4J_APPENDER_MYRFILE1_THRESHOLD}
#log4j.appender.MyRfile1.File=/home/tempvoice/jsonrpc.log
log4j.appender.MyRfile1.File=${LOG4J_APPENDER_MYRFILE1_FILE}
log4j.appender.MyRfile1.Append=${LOG4J_APPENDER_MYRFILE1_APPEND}
log4j.appender.MyRfile1.layout=${LOG4J_APPENDER_MYRFILE1_LAYOUT}
log4j.appender.MyRfile1.layout.ConversionPattern=${LOG4J_APPENDER_MYRFILE1_LAYOUT_CONVERSIONPATTERN}
log4j.appender.MyRfile1.DatePattern=${LOG4J_APPENDER_MYRFILE1_DATEPATTERN}
EOF

cd /apache-tomcat-8.5.34/webapps
jar -uf ability.war WEB-INF/classes/redis.properties
jar -uf ability.war WEB-INF/classes/jdbc.properties
jar -uf ability.war WEB-INF/classes/log4j.properties
rm -rf ability
cd /apache-tomcat-8.5.5/bin

exec "$@"