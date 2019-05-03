#!/bin/bash
#===============================================================================
#          FILE: gitlab_install_configurate.sh
#         USAGE: . ${YOUR_PATH}/gitlab_install_configurate.sh 
#   DESCRIPTION: 
#        AUTHOR: IVAN DU
#        E-MAIL: mrivandu@hotmail.com
#        WECHAT: ecsboy
#      TECHBLOG: https://ivandu.blog.csdn.net
#        GITHUB: https://github.com/mrivandu
#       CREATED: 2019-05-03 19:52:44
#       LICENSE: GNU General Public License.
#     COPYRIGHT: © IVAN DU 2019
#      REVISION: v1.0
#===============================================================================

# Stop and disable Firewalld.
systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux.

# Omnibus GitLab-ce package
# We can see: https://about.gitlab.com/install/#centos-7
yum -y install curl policycoreutils openssh-server openssh-client postfix
