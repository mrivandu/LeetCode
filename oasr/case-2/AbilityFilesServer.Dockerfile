FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /
ADD Thinkit_Offline_SystemD-v2.2.0_20200904.tar.gz /

# components.tar.xz:file  g++  gcc  make  supervisor zh-cn-utf8 bzip2
ADD components.tar.xz /

ADD [ "centos-7.8.2003-x86_64-docker.tar.xz","/os/" ]
COPY ability-file-sync.sh /os/usr/local/bin

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
    tar -xvzf /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/tools/java/jdk-7u45-linux-x64.gz -C /os; \
    tar -xvzf /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/tools/tomcat/apache-tomcat-8.5.5.20200817.tar.gz -C /os; \
    cp -r /usr/local/lib /os/usr/local/lib; \
    cp -r /zh-cn-utf8 /os/zh-cn-utf8; \
    cp -r /supervisor /os/supervisor; \
    cp /usr/lib64/libgomp.so.1 /os/usr/lib64/libgomp.so.1; \
    cp /lib64/libstdc++.so.6 /os/lib64/libstdc++.so.6; \
    cp -r /thinkit_offline_systemd/Thinkit_Offline_SystemD/System_Offline_Server/Offline_System_Client /os/Offline_System_Client; \
    chmod +x /os/usr/local/bin/*; \
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
    app01="FilesSync_Server" \
    app02="ability" \
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

ENV JAVA_HOME="/jdk1.7.0_45" \
    CLASSPATH=".:/jdk1.7.0_45/lib/dt.jar:/jdk1.7.0_45/lib/tools.jar"

# 设置tomcat环境变量。
ENV TOMCAT_HOME="/apache-tomcat-8.5.5" \
    CATALINA_HOME="/apache-tomcat-8.5.5" \
    CATALINA_BASE="/apache-tomcat-8.5.5"

# log4j.properties 相关的环境变量
ENV LOG4J_ROOTLOGGER="error, MyConsole, MyRfile1" \
    LOG4J_APPENDER_MYCONSOLE="org.apache.log4j.ConsoleAppender" \
    LOG4J_APPENDER_MYCONSOLE_THRESHOLD="debug" \
    LOG4J_APPENDER_MYCONSOLE_TARGET="System.out" \
    LOG4J_APPENDER_MYCONSOLE_LAYOUT="org.apache.log4j.PatternLayout" \
    LOG4J_APPENDER_MYCONSOLE_LAYOUT_CONVERSIONPATTERN="%d{yyyy-MM-dd HH:mm:ss} %p [%c] %m%n" \
    LOG4J_APPENDER_MYRFILE1="org.apache.log4j.DailyRollingFileAppender" \
    LOG4J_APPENDER_MYRFILE1_THRESHOLD="info" \
    LOG4J_APPENDER_MYRFILE1_FILE="/root/abilitylog/jsonrpc.log" \
    LOG4J_APPENDER_MYRFILE1_APPEND="true" \
    LOG4J_APPENDER_MYRFILE1_LAYOUT="org.apache.log4j.PatternLayout" \
    LOG4J_APPENDER_MYRFILE1_LAYOUT_CONVERSIONPATTERN="%d - %m%n" \
    LOG4J_APPENDER_MYRFILE1_DATEPATTERN="\'.\'yyyy-MM-dd"

# redis.properties 相关环境变量。
ENV ISCLUSTER="true" \
    REDISADD="192.168.187.91:3187,192.168.187.92:3187,192.168.187.93:3187,192.168.187.94:3187,192.168.187.95:3187,192.168.187.96:3187" \
    REDIS_SERVER="172.17.0.2" \
    REDIS_PORT="30010" \
    REDIS_QUEUE="voicetask" \
    CONNECTIONTIMEOUT="2000" \
    SOTIMEOUT="2000" \
    MAXATTEMPTS="6" \
    REDISPASSWORD="yydh0217" \
    VOICETEMPPATH="/root/tempvoice" \
    GRSSLEEPTIME="1000" \
    INITIALCAPACITY="1000" \
    MAXIMUMSIZE="1000"

# jdbc.properties 相关环境变量。
ENV DRIVER="com.mysql.jdbc.Driver" \
    URL="jdbc:mysql://192.168.96.89:3306/offline_system_d?&characterEncoding" \
    USERNAME="thinkit_offline_asr" \
    PASSWORD="thinkit_offline_asr@123$"

ENV LD_LIBRARY_PATH="/usr/local/lib/ffmpeg-3.0/lib:/usr/local/lib/sox-14.4.1/lib:/usr/local/lib/protobuf-2.5.0/lib:/Offline_System_Client/lib:${LD_LIBRARY_PATH}" \
    LIBRARY_PATH="/usr/local/lib/ffmpeg-3.0/lib:/usr/local/lib/sox-14.4.1/lib:/usr/local/lib/protobuf-2.5.0/lib:${LIBRARY_PATH}" \
    PKG_CONFIG_PATH="/usr/local/lib/ffmpeg-3.0/lib/pkgconfig:/usr/local/lib/sox-14.4.1/lib/pkgconfig:/usr/local/lib/protobuf-2.5.0/lib/pkgconfig:${PKG_CONFIG_PATH}" \
    CPLUS_INCLUDE_PATH="/usr/local/lib/ffmpeg-3.0/include:/usr/local/lib/sox-14.4.1/include:/usr/local/lib/protobuf-2.5.0/include:${CPLUS_INCLUDE_PATH}" \
    C_INCLUDE_PATH="/usr/local/lib/ffmpeg-3.0/include:/usr/local/lib/sox-14.4.1/include:/usr/local/lib/protobuf-2.5.0/include:${C_INCLUDE_PATH}" \
    PATH="/jdk1.7.0_45/bin:/apache-tomcat-8.5.5/bin:/Offline_System_Client:/usr/local/lib/ffmpeg-3.0/bin:/usr/local/lib/sox-14.4.1/bin:/usr/local/lib/protobuf-2.5.0/bin:${PATH}"

WORKDIR \
    /Offline_System_Client

# File_Sync_Server
ENV THREAD_NUM="10" \
    IPADDRESS="127.0.0.1" \
    PORT="29090" \
    LOGLEVEL="2"

ENTRYPOINT \
    [ "ability-file-sync.sh" ]

EXPOSE \
    20101 20103 20104 29090

CMD [ "/usr/bin/supervisord","-c","/etc/supervisord.conf" ]