FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /
ADD comm.tar.gz /

RUN set -eux; \
    cd zh-cn-utf8; \
    rpm -ivh kde-filesystem-4-47.el7.x86_64.rpm  \
             kde-l10n-4.10.5-2.el7.noarch.rpm  \
             kde-l10n-Chinese-4.10.5-2.el7.noarch.rpm; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    cd /gcc; \
    rpm -ivh *; \
    cd /g++; \
    rpm -ivh --force *; \
    cd make; \
    rmp -ivh *; \
    cd /file; \
    rpm -ivh *; \
    cd /bzip2; \
    rmp -ivh *; \
    cd /;\
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
    tar -cvzf compile.tar.gz /usr/local/lib/*; \
    rm -rf /var/cache/yum/* zh-cn-utf8* gcc g++ file bzip2 ffmpeg-3.0* protobuf-2.5.0* sox-14.4.1* comm.tar.gz

FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /

LABEL \
    system="oasr" \
    app="Offline_System_Client" \
    vendor="CMOS" \
    author="Ivan Du" \
    version="2.1.2"