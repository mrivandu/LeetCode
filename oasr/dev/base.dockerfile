FROM scratch

ADD centos-7.8.2003-x86_64-docker.tar.xz /
# URL:https://github.com/CentOS/sig-cloud-instance-images/raw/216a920c467977bbd0f456d3bc381100a88b3768/docker/centos-7.8.2003-x86_64-docker.tar.xz /

LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="CentOS Base Image" \
    org.label-schema.vendor="CentOS" \
    org.label-schema.license="GPLv2" \
    org.label-schema.build-date="20200504" \
    org.opencontainers.image.title="CentOS Base Image" \
    org.opencontainers.image.vendor="CentOS" \
    org.opencontainers.image.licenses="GPL-2.0-only" \
    org.opencontainers.image.created="2020-05-04 00:00:00+01:00" \
    system="oasr" \
    vendor="CMOS" \
    author="Ivan Du" \
    version="2.1.2"

SHELL \
     ["/bin/bash", "-c"]

 RUN set -eux; \
    yum install -y kde-l10n-Chinese -y; \
    yum install -y glibc-common; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf; \
    yum -y install epel-release; \
    yum -y install supervisor; \
    yum -y gcc \
           gcc-c++\
           make \
           file\ 
           bzip2; \
    yum clean all; \
    rm -rf /var/cache/yum/*

ENV \
    TZ="Asia/Shanghai" \
    LANG="zh_CN.UTF-8"

CMD [ "/bin/bash" ]

