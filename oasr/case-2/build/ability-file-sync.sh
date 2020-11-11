#!/bin/bash
# Author:DURUIHONG
# Build time: 2020-11-11
# E-mail:duruihong@cmos.chinamobile.com

set -eux

export IPADDRESS=`hostname -i`
sed -i "21s/nodaemon=false/nodaemon=true/g" /etc/supervisord.conf
sed -i "25s/;user=chrism/user=root/g" /etc/supervisord.conf

mkdir -p /apache-tomcat-8.5.5/webapps/WEB-INF/classes
cat>/apache-tomcat-8.5.5/webapps/WEB-INF/classes/redis.properties<<-EOF
isCluster=${ISCLUSTER}
redisAdd=${REDISADD}
redis.server=${REDIS_SERVER}
redis.port=${REDIS_PORT}
redis.queue=${REDIS_QUEUE}
connectionTimeout=${CONNECTIONTIMEOUT}
soTimeout=${SOTIMEOUT}
maxAttempts=${MAXATTEMPTS}
redisPassword=${REDISPASSWORD}
voiceTempPath=${VOICETEMPPATH}
grsSleepTime=${GRSSLEEPTIME}
initialCapacity=${INITIALCAPACITY}
maximumSize=${MAXIMUMSIZE}
EOF

cat>/apache-tomcat-8.5.5/webapps/WEB-INF/classes/jdbc.properties<<-EOF
driver=${DRIVER}
url=${URL}
username=${USERNAME}
password=${PASSWORD}
EOF

cat>/apache-tomcat-8.5.5/webapps/WEB-INF/classes/log4j.properties<<-EOF
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

cd /apache-tomcat-8.5.5/webapps
jar -uf ability.war WEB-INF/classes/redis.properties
jar -uf ability.war WEB-INF/classes/jdbc.properties
jar -uf ability.war WEB-INF/classes/log4j.properties
rm -rf WEB-INF
cd /Offline_System_Client

cat>/etc/supervisord.d/ability.ini<<-EOF
[program:ability]
command=catalina.sh run              ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
directory=/apache-tomcat-8.5.5/bin               ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=999                  ; the relative start priority (default 999)
;autostart=true                ; start at supervisord start (default: true)
;autorestart=true              ; retstart at unexpected quit (default: true)
;startsecs=10                  ; number of secs prog must stay running (def. 1)
;startretries=3                ; max # of serial start failures (default 3)
;exitcodes=0,2                 ; 'expected' exit codes for process (default 0,2)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=true          ; redirect proc stderr to stdout (default false)
;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
;stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
;stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;environment=A=1,B=2           ; process environment additions (def no adds)
;serverurl=AUTO                ; override serverurl computation (childutils)
EOF

cat>/etc/supervisord.d/FilesSync_Server.ini<<-EOF
[program:FilesSync_Server]
command=FilesSync_Server ${THREAD_NUM} ${IPADDRESS} ${PORT} ${LOGLEVEL}              ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
directory=/Offline_System_Client               ; directory to cwd to before exec (def no cwd)
;umask=022                     ; umask for process (default None)
;priority=999                  ; the relative start priority (default 999)
;autostart=true                ; start at supervisord start (default: true)
;autorestart=true              ; retstart at unexpected quit (default: true)
;startsecs=10                  ; number of secs prog must stay running (def. 1)
;startretries=3                ; max # of serial start failures (default 3)
;exitcodes=0,2                 ; 'expected' exit codes for process (default 0,2)
;stopsignal=QUIT               ; signal used to kill process (default TERM)
;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
;user=chrism                   ; setuid to this UNIX account to run the program
;redirect_stderr=true          ; redirect proc stderr to stdout (default false)
;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
;stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stdout_events_enabled=false   ; emit events on stdout writes (default false)
;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
;stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
;stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
;stderr_events_enabled=false   ; emit events on stderr writes (default false)
;environment=A=1,B=2           ; process environment additions (def no adds)
;serverurl=AUTO                ; override serverurl computation (childutils)
EOF

exec "$@"
