FROM baseImage

LABEL author="duruihong" e-mail="duruihong@cmos.chinamobile.com" vendor="cmos" name="asrability" version="2.2.1"
 
# 定义时区参数和编码字符集。
ENV TZ="Asia/Shanghai" \
    LANG="en_US.UTF-8"


# 复制入口文件。
COPY docker-entrypoint.sh /usr/local/bin

# 设置JDK环境变量值。
ENV _JAVA_OPTIONS="-Xms1024m -Xmx2048m" \
    JAVA_HOME="/jdk1.7.0_45" \
    CLASSPATH=".:/jdk1.7.0_45/lib/dt.jar:/jdk1.7.0_45/lib/tools.jar"

# 设置tomcat环境变量。
ENV TOMCAT_HOME="/apache-tomcat-8.5.5" \
    CATALINA_HOME="apache-tomcat-8.5.5" \
    CATALINA_BASE="apache-tomcat-8.5.5"

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
ENV ISCLUSTER="false" \
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

# 执行路径加入环境变量。
ENV PATH="/jdk1.7.0_45/bin:/apache-tomcat-8.5.5/bin:$PATH"

# 默认工作目录。
WORKDIR /apache-tomcat-8.5.5/bin 

# 从第一阶段复制必要运行文件。
COPY jdk1.7.0_45 /jdk1.7.0_45
COPY apache-tomcat-8.5.5 /apache-tomcat-8.5.5

# 启动执行的脚本。
ENTRYPOINT ["docker-entrypoint.sh"]

# 设置暴露端口。
EXPOSE 20101 20103 20104

# 默认启动命令。
CMD ["catalina.sh", "run"]
