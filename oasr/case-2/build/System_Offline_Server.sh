#!/bin/bash
# Author:DURUIHONG
# Build time: 2020-11-11
# E-mail:duruihong@cmos.chinamobile.com

set -eux

export IPADDRESS=`hostname -i`
sed -i "21s/nodaemon=false/nodaemon=true/g" /etc/supervisord.conf
sed -i "25s/;user=chrism/user=root/g" /etc/supervisord.conf

# ClusterSceneServer
cat>/etc/supervisord.d/ClusterSceneServer.ini<<-EOF
[program:ClusterSceneServer]
command=Cluster_Scene_server_test -ipAddr ${IPADDR} -ports ${PORTS} -roleServerPort ${ROLESERVERPORT} -ABFormat ${ABFORMAT} -delSpace ${DELSPACE} -nThread ${NTHREAD} -logFile ${LOGTXT}              ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
directory=/ClusterSceneServer               ; directory to cwd to before exec (def no cwd)
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

cat>/ClusterSceneServer/configure.cfg<<-EOF
<ClusterCfg>
iDstClusterNum=${IDSTCLUSTERNUM}
iSingleMinTimeSec=${ISINGLEMINTIMESEC}
iSingleOutTimeSec=${ISINGLEOUTTIMESEC}
ClusterDisType=${CLUSTERDISTYPE}
TimeSegMode=${TIMESEGMODE}
iKMeansTimes=${IKMEANSTIMES}
iFeatFramePeriodMSec=${IFEATFRAMEPERIODMSEC}
iFeatFrameStepPeriodMSec=${IFEATFRAMESTEPPERIODMSEC}
fCombinedTimeMSec=${FCOMBINEDTIMEMSEC}
save_blank=${SAVE_BLANK}
BreakPointDetect=${BREAKPOINTDETECT}
WriteBreakPointLog=${WRITEBREAKPOINTLOG}
logTxt=${LOGTXT}
bpRuleCfg=${BPRULECFG}
HighPassPro=${HIGHPASSPRO}
FC=${FC}
dBGain=${DBGAIN}

fClusBicAlpha=${FCLUSBICALPHA}
shortTimeThreshold=${SHORTTIMETHRESHOLD}
pitchThreshold=${PITCHTHRESHOLD}
energyThreshold=${ENERGYTHRESHOLD}
shortSegNumThreshold=${SHORTSEGNUMTHRESHOLD}
shortTimeFilterByKmeans=${SHORTTIMEFILTERBYKMEANS}
pitchFeatureEnable=${PITCHFEATUREENABLE}
pitchFeature1OrderEnable=${PITCHFEATURE1ORDERENABLE}
energyFeatureEnable=${ENERGYFEATUREENABLE}

<License>
iLicense=${ILICENSE}
EOF

# DetectOverlap
cat>/etc/supervisord.d/DetectOverlap.ini<<-EOF
[program:DetectOverlap]
command=DetectOverlapPro -nThread ${NTHREAD} -config in.cfg  -ip ${IP} -port ${PORTS}              ; the program (relative uses PATH, can take args)
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

cat>/DetectOverlap/in.cfg<<EOF
nThread=${NTHREAD}
LicenceFile=${LICENCEFILE}
IN_DATA_FORMAT=${IN_DATA_FORMAT}
FE_LOG_FILE=${FE_LOG_FILE}

#extract_feat
EXTRACT_FEAT_CFG=${EXTRACT_FEAT_CFG}

#dnn_vad
Dnn_Vad=${DNN_VAD}
DNN_VAD_CFG=${DNN_VAD_CFG}

#detect overlap; DNN_Vad must be true, and DetectEmotion must be false
DetectOverlap=${DETECTOVERLAP}
DETECT_OVERLAP_CFG=${DETECT_OVERLAP_CFG}
EOF

# Offline_System_Client
cat>/etc/supervisord.d/custom_client_multiserver.ini<<-EOF
[program:custom_client_multiserver]
command=custom_client_multiserver             ; the program (relative uses PATH, can take args)
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

cat>/Offline_System_Client/cfg.ini<<-EOF
[general]
#数据库相关
MysqlServerIP=${MYSQLSERVERIP}
MysqlServerPort=${MYSQLSERVERPORT}
MysqlDatabase=${MYSQLDATABASE}
MysqlUser=${MYSQLUSER}
MysqlPassword=${MYSQLPASSWORD}

#引擎服务器标识
processorId=${PROCESSORID}

#redis服务相关
redisCluster=${REDISCLUSTER}
#redis单节点地址
redisIp=${REDISIP}
redisPort=${REDISPORT}
#redis集群地址
redisAdd=${REDISADD}
#redis集群密码
redisPass=${REDISPASS}
redisTaskList=${REDISTASKLIST}
redisNotifyList=${REDISNOTIFYLIST}

#声道数 Mono：单  Stereo：双
channels=${CHANNELS}

#语种 zhn：中文，eng：英语
language=${LANGUAGE}

#关键词列表
keywordlist=${KEYWORDLIST}

#存放xml结果的目录后缀
xmlPathPostfix=${XMLPATHPOSTFIX}

#DeleteTempResult：是否删除中间结果
DeleteTempResult=${DELETETEMPRESULT}

#DeleteOriginalWav：是否删除原始语音
DeleteOriginalWav=${DELETEORIGINALWAV}

#maxHandleThread：并行处理语音最大线数
maxHandleThread=${MAXHANDLETHREAD}

#判断超时时长，语音时长的倍数
timeoutRate=${TIMEOUTRATE}
#检查的频率
checkPeriod=${CHECKPERIOD}

taskCtrlShell=${TASKCTRLSHELL}

#wavFormat:语音格式
#  1：128kbps的pcm: 8k_16bit_PCM
wavFormat=${WAVFORMAT}

#stereo_on:双声道语音转码方式，取值及说明如下：
#  1：指单声道或者将分录双声道合并成单声道进行处理
#  2：指将分录双声道的左右声道解码成两个单声道
#  3：指将分录双声道的左右声道解码成两个单声道同时，还需合并成一个单声道
#  4：指合录双声道，左右声道内容一样，都是多个人的对话
stereo_on=${STEREO_ON}

#logEvents：需要打的日志级别 0-15，小于设定值的日志将被写入日志文件。参见如下宏定义；
#  0：不输出日志    
#  1：fatal errors, UL_LOG_FATAL 
#  2：exceptional events, UL_LOG_WARNING 
#  4：informational notices, UL_LOG_NOTICE
#  8：program tracing, UL_LOG_TRACE
logEvents=${LOGEVENTS}

#logToSyslog：输出到syslog 中的日志级别, 0-15，参见logEvents部分的宏定义   
logToSyslog=${LOGTOSYSLOG}

#logSpec：扩展开关 0 or @ref UL_LOGTTY or @ref UL_LOGNEWFILE，参见如下宏定义；
#  2   /**<   日志在输出到日志文件的同时输出到标准出错(stderr)中 */
#  8    /**<   创建新的日志文件,可以使每个线程都把日志打到不同文件中*/
#  16    /**<  按大小分割日志文件，不回滚*/    
logSpec=${LOGSPEC}

#logMaxLen,单个日志文件的最大长度（单位: MB）
logMaxLen=${LOGMAXLEN}

[server]
#请保持各参数的相对位置，不要随意改变
KwsAndRecServer=${KWSANDRECSERVER}
KwsAndRecServerIP=${KWSANDRECSERVERIP}
KwsAndRecServerPort=${KWSANDRECSERVERPORT}
ClusterAndSceneServer=${CLUSTERANDSCENESERVER}
ClusterAndSceneServerIP=${CLUSTERANDSCENESERVERIP}
ClusterAndSceneServerPort=${CLUSTERANDSCENESERVERPORT}
InterruptionServer=${INTERRUPTIONSERVER}
InterruptionServerIP=${INTERRUPTIONSERVERIP}
InterruptionServerPort=${INTERRUPTIONSERVERPORT}
XMLServer=${XMLSERVER}
XMLServerIP=${XMLSERVERIP}
XMLServerPort=${XMLSERVERPORT}
EOF

# TBNR_release_time
cat>/etc/supervisord.d/TBNR_release_time.ini<<-EOF
[program:TBNR_release_time]
command=offline_customer_server_test_dnnvad -ip ${IP} -port ${PORTS} -format 8K_16BIT_PCM -sysDir ../model -num ${LINENUM} -config WFSTDecoder-inputMethod_dnn_onlyrec.cfg  -tel2Num ${TEL2NUM}             ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
directory=/TBNR_release_time/bin               ; directory to cwd to before exec (def no cwd)
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

# xml_server
cat>/etc/supervisord.d/xml_server.ini<<-EOF
[program:xml_server]
command=XMLServer -ipAddr ${IP} -ports ${PORTS} -nThread ${NTHREAD}             ; the program (relative uses PATH, can take args)
;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
;numprocs=1                    ; number of processes copies to start (def 1)
directory=/xml_server               ; directory to cwd to before exec (def no cwd)
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
