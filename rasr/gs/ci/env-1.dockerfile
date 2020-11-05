FROM centos:7.4.1708

LABEL author="duruihong" e-mail="duruihong@cmos.chinamobile.com" vendor="cmos" name="decoder" version="1.0"

ENV TZ="Asia/Shanghai" \
    LANG="en_US.UTF-8"

RUN set -eux; \
    yum -y install expect \
                openssh-clients
#    rpm -ivh /pkgs/libedit-3.0-12.20121213cvs.el7.x86_64.rpm \
#             /pkgs/fipscheck-lib-1.4.1-6.el7.x86_64.rpm \
#             /pkgs/fipscheck-1.4.1-6.el7.x86_64.rpm \
#             /pkgs/openssh-7.4p1-21.el7.x86_64.rpm \
#             /pkgs/openssh-clients-7.4p1-21.el7.x86_64.rpm \
#             /pkgs/tcl-8.5.13-8.el7.x86_64.rpm \
#             /pkgs/expect-5.45-14.el7_1.x86_64.rpm; \