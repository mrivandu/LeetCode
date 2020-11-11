FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /
ADD Thinkit_Offline_SystemD-v2.2.0_20200904.tar.gz /

# components.tar.xz:file  g++  gcc  make  supervisor zh-cn-utf8 bzip2
ADD components.tar.xz /

ADD [ "centos-7.8.2003-x86_64-docker.tar.xz","/os/" ]
COPY System_Offline_Server.sh /os/usr/local/bin

RUN set -eux; \
    cd zh-cn-utf8; \
    rpm -ivh *; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    cd /gcc; \
    rpm -ivh *; \
    cd /g++; \
    rpm -ivh --force *; \
    cd /make; \
    rpm -ivh *; \
    cd /file; \
    rpm -ivh *; \
    cd /bzip2; \
    rpm -ivh *; \
    cd /; \
    tar -xvjf /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/tools/ffmpeg/ffmpeg-3.0.tar.bz2; \
    cd ffmpeg-3.0; \
    mkdir /usr/local/lib/ffmpeg-3.0; \
    ./configure --disable-yasm --enable-shared --prefix=/usr/local/lib/ffmpeg-3.0; \
    make clean; \
    make -j `cat /proc/cpuinfo | grep processor | wc -l`; \
    make install; \
    cd /;\
    tar -xvzf /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/tools/sox/sox-14.4.1.tar.gz; \
    cd sox-14.4.1; \
    mkdir /usr/local/lib/sox-14.4.1; \
    ./configure --prefix=/usr/local/lib/sox-14.4.1; \
    make clean; \
    make -j `cat /proc/cpuinfo | grep processor | wc -l`; \
    make install; \
    cd /; \
    tar -xvzf /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/tools/protobuf/protobuf-2.5.0.tar.gz; \
    cd protobuf-2.5.0; \
    mkdir /usr/local/lib/protobuf-2.5.0; \
    ./configure --prefix=/usr/local/lib/protobuf-2.5.0; \
    make clean; \
    make -j `cat /proc/cpuinfo | grep processor | wc -l`; \
    make install; \
    cd /; \
    cp -r /usr/local/lib /os/usr/local/lib; \
    cp -r /zh-cn-utf8 /os/zh-cn-utf8; \
    cp -r /supervisor /os/supervisor; \
    cp /usr/lib64/libgomp.so.1 /os/usr/lib64/libgomp.so.1; \
    cp /lib64/libstdc++.so.6 /os/lib64/libstdc++.so.6; \
    cp -r /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/{ClusterSceneServer,DetectOverlap,Offline_System_Client,TBNR_release_time,xml_server} /os/; \
    rm -rf /os/var/cache/yum/* \
           zh-cn-utf8* gcc g++ \
           file bzip2 ffmpeg-3.0* \
           protobuf-2.5.0* sox-14.4.1* \
           /os/anaconda-post.log \
           /os/root/anaconda-ks.cfg \
           supervisor

FROM scratch

LABEL \
    system="oasr" \
    app01="ClusterSceneServer" \
    app02="DetectOverlap" \
    app03="Offline_System_Client" \
    app04="TBNR_release_time" \
    app05="xml_server" \
    vendor="CMOS" \
    author="Ivan Du" \
    version="2.2.1"

COPY --from=0 /os /

RUN set -eux; \
    cd zh-cn-utf8; \
    rpm -ivh *; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    cd /supervisor; \
    rpm -ivh *; \
    ulimit -c unlimited; \
    rm -rf /zh-cn-utf8 /supervisor /var/cache/yum/*

ENV TZ="Asia/Shanghai" \
    LANG="zh_CN.UTF-8"

ENV LD_LIBRARY_PATH="/usr/local/lib/ffmpeg-3.0/lib:/usr/local/lib/sox-14.4.1/lib:/usr/local/lib/protobuf-2.5.0/lib:/Offline_System_Client/lib:${LD_LIBRARY_PATH}" \
    LIBRARY_PATH="/usr/local/lib/ffmpeg-3.0/lib:/usr/local/lib/sox-14.4.1/lib:/usr/local/lib/protobuf-2.5.0/lib:${LIBRARY_PATH}" \
    PKG_CONFIG_PATH="/usr/local/lib/ffmpeg-3.0/lib/pkgconfig:/usr/local/lib/sox-14.4.1/lib/pkgconfig:/usr/local/lib/protobuf-2.5.0/lib/pkgconfig:${PKG_CONFIG_PATH}" \
    CPLUS_INCLUDE_PATH="/usr/local/lib/ffmpeg-3.0/include:/usr/local/lib/sox-14.4.1/include:/usr/local/lib/protobuf-2.5.0/include:${CPLUS_INCLUDE_PATH}" \
    C_INCLUDE_PATH="/usr/local/lib/ffmpeg-3.0/include:/usr/local/lib/sox-14.4.1/include:/usr/local/lib/protobuf-2.5.0/include:${C_INCLUDE_PATH}" \
    PATH="/xml_server:/DetectOverlap/lib:/TBNR_release_time/bin:/ClusterSceneServer:/Offline_System_Client:/usr/local/lib/ffmpeg-3.0/bin:/usr/local/lib/sox-14.4.1/bin:/usr/local/lib/protobuf-2.5.0/bin:${PATH}"

# ClusterSceneServer
ENV IDSTCLUSTERNUM="2" \
    ISINGLEMINTIMESEC="0.1" \
    ISINGLEOUTTIMESEC="10800" \
    CLUSTERDISTYPE="GLR2" \
    TIMESEGMODE="ORIGINAL" \
    IKMEANSTIMES="10" \
    IFEATFRAMEPERIODMSEC="40" \
    IFEATFRAMESTEPPERIODMSEC="20" \
    FCOMBINEDTIMEMSEC="0.01" \
    SAVE_BLANK="false" \
    BREAKPOINTDETECT="false" \
    WRITEBREAKPOINTLOG="false" \
    LOGTXT="log.txt" \
    BPRULECFG="bp_rule.cfg" \
    HIGHPASSPRO="true" \
    FC="26" \
    DBGAIN="65" \
    FCLUSBICALPHA="0" \
    SHORTTIMETHRESHOLD="500" \
    PITCHTHRESHOLD="50" \
    ENERGYTHRESHOLD="10" \
    SHORTSEGNUMTHRESHOLD="0" \
    SHORTTIMEFILTERBYKMEANS="false" \
    PITCHFEATUREENABLE="True" \
    PITCHFEATURE1ORDERENABLE="false" \
    ENERGYFEATUREENABLE="True" \
    ILICENSE="license.dat"

# 与总控端通信端口:PORTS=6609
# 角色区分服务端口：ROLESERVERPORT=20101
# IPADDR:Tomcat
ENV LD_LIBRARY_PATH="/ClusterSceneServer/lib:/ClusterSceneServer/Cluster:/ClusterSceneServer/KWSAPI_LIBLINUX:${LD_LIBRARY_PATH}" \
    IPADDR="127.0.0.1" \
    PORTS="6609" \
    ROLESERVERPORT="20101" \
    ABFORMAT="AABB" \
    DELSPACE="true" \
    NTHREAD="3"

# DetectOverlap
ENV NTHREAD="20" \
    LICENCEFILE="license.dat" \
    IN_DATA_FORMAT="FE_8K_16BIT_PCM" \
    FE_LOG_FILE="frontend.log" \
    EXTRACT_FEAT_CFG="source/extract_feat/WFSTDecoder-inputMethod_dnn_offline_s3_new_kws+rec.cfg" \
    DNN_VAD="true" \
    DNN_VAD_CFG="source/dnn_vad/dnn_vad.cfg" \
    DETECTOVERLAP="true" \
    DETECT_OVERLAP_CFG="source/detect_overlap/detect_overlap.cfg" \
    LD_LIBRARY_PATH="DetectOverlap/:DetectOverlap/lib:${LD_LIBRARY_PATH}" \
    IP="127.0.0.1" \
    PORTS="6610"

# Offline_System_Client
ENV MYSQLSERVERIP="192.168.96.89" \
    MYSQLSERVERPORT="3306" \
    MYSQLDATABASE="offline_system_d" \
    MYSQLUSER="thinkit_offline_asr" \
    MYSQLPASSWORD="thinkit_offline_asr@123$" \
    PROCESSORID="127.0.0.1:node_A" \
    REDISCLUSTER="true" \
    REDISIP="192.168.96.86" \
    REDISPORT="30010" \
    REDISADD="192.168.96.87:7010,192.168.96.87:7011,192.168.96.87:7012,192.168.96.87:7013,192.168.96.87:7014,192.168.96.87:7015" \
    REDISPASS="foobared" \
    REDISTASKLIST="voicetask" \
    REDISNOTIFYLIST="thinkit_notify_zyzx" \
    CHANNELS="Mono" \
    LANGUAGE="zhn" \
    KEYWORDLIST="~/keyword.txt" \
    XMLPATHPOSTFIX="_Xml" \
    DELETETEMPRESULT="true" \
    DELETEORIGINALWAV="true" \
    MAXHANDLETHREAD="20" \
    TIMEOUTRATE="5" \
    CHECKPERIOD="43200" \
    TASKCTRLSHELL="/Offline_System_Client/ctrlTask.sh" \
    WAVFORMAT="1" \
    STEREO_ON="1" \
    LOGEVENTS="5" \
    LOGTOSYSLOG="0" \
    LOGSPEC="16" \
    LOGMAXLEN="100" \
    KWSANDRECSERVER="true" \
    KWSANDRECSERVERIP="127.0.0.1" \
    KWSANDRECSERVERPORT="6608" \
    CLUSTERANDSCENESERVER="true" \
    CLUSTERANDSCENESERVERIP="127.0.0.1" \
    CLUSTERANDSCENESERVERPORT="6609" \
    INTERRUPTIONSERVER="true" \
    INTERRUPTIONSERVERIP="127.0.0.1" \
    INTERRUPTIONSERVERPORT="6610" \
    XMLSERVER="true" \
    XMLSERVERIP="127.0.0.1" \
    XMLSERVERPORT="6613"

# TBNR_release_time
ENV LD_LIBRARY_PATH="/TBNR_release_time/bin:/TBNR_release_time/KWSAPI_ENV/KWSAPI_LIBLINUX:${LD_LIBRARY_PATH}" \
    TEL2NUM="false" \
    LINENUM="2" \
    PORTS="6608"

# xml_server
ENV PORTS="6613" \
    NTHREAD="1" \
    BADDPUNCTUATION="true" \
    LD_LIBRARY_PATH="./lib:${LD_LIBRARY_PATH}"

EXPOSE 6608/tcp 6609/tcp 6610/tcp 6613/tcp

ENTRYPOINT \
    [ "System_Offline_Server.sh" ]

CMD [ "/usr/bin/supervisord","-c","/etc/supervisord.conf" ]