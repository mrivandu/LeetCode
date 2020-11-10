FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /
ADD comm.tar.gz /

COPY \
    centos-7.8.2003-x86_64-docker.tar.xz /centos-7.8.2003-x86_64-docker.tar.xz

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
    tar -xvjf ffmpeg-3.0.tar.bz2; \
    cd ffmpeg-3.0; \
    mkdir /usr/local/lib/ffmpeg-3.0; \
    ./configure --disable-yasm --enable-shared --prefix=/usr/local/lib/ffmpeg-3.0; \
    make clean; \
    make -j `cat /proc/cpuinfo | grep processor | wc -l`; \
    make install; \
    cd /;\
    tar -xvzf sox-14.4.1.tar.gz; \
    cd sox-14.4.1; \
    mkdir /usr/local/lib/sox-14.4.1; \
    ./configure --prefix=/usr/local/lib/sox-14.4.1; \
    make clean; \
    make -j `cat /proc/cpuinfo | grep processor | wc -l`; \
    make install; \
    cd /; \
    tar -xvzf protobuf-2.5.0.tar.gz; \
    cd protobuf-2.5.0; \
    mkdir /usr/local/lib/protobuf-2.5.0; \
    ./configure --prefix=/usr/local/lib/protobuf-2.5.0; \
    make clean; \
    make -j `cat /proc/cpuinfo | grep processor | wc -l`; \
    make install; \
    cd /; \
    tar -cvzf achievements.tar.gz /usr/local/lib/* /zh-cn-utf8; \
    mkdir /os; \
    tar -xvJf /centos-7.8.2003-x86_64-docker.tar.xz -C /os; \
    cp /usr/lib64/libgomp.so.1 /os/usr/lib64/libgomp.so.1; \
    cp /lib64/libstdc++.so.6 /os/lib64/libstdc++.so.6; \
    cp -r Offline_System_Client /os/Offline_System_Client; \
    rm -rf /var/cache/yum/* zh-cn-utf8* gcc g++ file bzip2 ffmpeg-3.0* protobuf-2.5.0* sox-14.4.1* comm.tar.gz /centos-7.8.2003-x86_64-docker.tar.xz

FROM scratch

LABEL \
    system="oasr" \
    app="Offline_System_Client" \
    vendor="CMOS" \
    author="Ivan Du" \
    version="2.1.2"

COPY \
    --from=0 [ "/achievements.tar.gz","/os","/" ]

RUN set -eux; \
    tar -xvzf achievements.tar.gz; \
    cd /zh-cn-utf8; \
    rpm -ivh *; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    rm -rf /var/cache/yum/* \
           /achievements.tar.gz \
           /zh-cn-utf8  \
           /centos-7.8.2003-x86_64-docker.tar.xz \
           /anaconda-post.log; \
    ulimit -c unlimited

# 定义时区参数和编码字符集。
ENV TZ="Asia/Shanghai" \
    LANG="zh_CN.UTF-8"

ENV LD_LIBRARY_PATH="/usr/local/lib/ffmpeg-3.0/lib:/usr/local/lib/sox-14.4.1/lib:/usr/local/lib/protobuf-2.5.0/lib:/Offline_System_Client/lib:${LD_LIBRARY_PATH}" \
    LIBRARY_PATH="/usr/local/lib/ffmpeg-3.0/lib:/usr/local/lib/sox-14.4.1/lib:/usr/local/lib/protobuf-2.5.0/lib:${LIBRARY_PATH}" \
    PKG_CONFIG_PATH="/usr/local/lib/ffmpeg-3.0/lib/pkgconfig:/usr/local/lib/sox-14.4.1/lib/pkgconfig:/usr/local/lib/protobuf-2.5.0/lib/pkgconfig:${PKG_CONFIG_PATH}" \
    CPLUS_INCLUDE_PATH="/usr/local/lib/ffmpeg-3.0/include:/usr/local/lib/sox-14.4.1/include:/usr/local/lib/protobuf-2.5.0/include:${CPLUS_INCLUDE_PATH}" \
    C_INCLUDE_PATH="/usr/local/lib/ffmpeg-3.0/include:/usr/local/lib/sox-14.4.1/include:/usr/local/lib/protobuf-2.5.0/include:${C_INCLUDE_PATH}" \
    PATH="/usr/local/lib/ffmpeg-3.0/bin:/usr/local/lib/sox-14.4.1/bin:/usr/local/lib/protobuf-2.5.0/bin:${PATH}"

CMD [ "/bin/bash","-c","bash" ]