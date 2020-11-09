FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /

LABEL \
    system="oasr" \
    app="Cluster_Scene_server_test" \
    vendor="CMOS" \
    author="Ivan Du" \
    version="2.1.2"

ADD zh-cn-utf8.tar.gz /

RUN set -eux; \
    cd zh-cn-utf8; \
    rpm -ivh kde-filesystem-4-47.el7.x86_64.rpm  \
             kde-l10n-4.10.5-2.el7.noarch.rpm  \
             kde-l10n-Chinese-4.10.5-2.el7.noarch.rpm; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    rm -rf /var/cache/yum/* /zh-cn-utf8

# 定义时区参数和编码字符集。
ENV TZ="Asia/Shanghai" \
    LANG="zh_CN.UTF-8"

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

WORKDIR /ClusterSceneServer

# 与总控端通信端口:PORTS=6609
# 角色区分服务端口：ROLESERVERPORT=20101
# IPADDR:Tomcat
ENV LD_LIBRARY_PATH="./lib:./Cluster:./KWSAPI_LIBLINUX:${LD_LIBRARY_PATH}" \
    IPADDR="127.0.0.1" \
    PORTS="6609" \
    ROLESERVERPORT="20101" \
    ABFORMAT="AABB" \
    DELSPACE="true" \
    NTHREAD="3" \
    PATH="/ClusterSceneServer:${PATH}"

COPY /ClusterSceneServer /ClusterSceneServer
COPY [ "docker-entrypoint.sh","tini","/usr/local/bin/" ]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6609/tcp

CMD [ "/bin/bash","-c","exec tini -- Cluster_Scene_server_test -ipAddr ${IPADDR} -ports ${PORTS} -roleServerPort ${ROLESERVERPORT} -ABFormat ${ABFORMAT} -delSpace ${DELSPACE} -nThread ${NTHREAD} -logFile ${LOGTXT}" ]