#!/bin/bash
#===============================================================================
#          FILE: system_init.sh
#         USAGE: . ${YOUR_PATH}/system_init.sh 
#   DESCRIPTION: 
#        AUTHOR: IVAN DU
#        E-MAIL: mrivandu@hotmail.com
#        WECHAT: ecsboy
#      TECHBLOG: https://ivandu.blog.csdn.net
#        GITHUB: https://github.com/mrivandu
#       CREATED: 2019-05-03 20:52:39
#       LICENSE: GNU General Public License.
#     COPYRIGHT: © IVAN DU 2019
#      REVISION: v1.0
#===============================================================================

# Stop and disable Firewalld.
systemctl stop firewalld
systemctl disable firewalld

# Disable SELinux.
sed -i 's/^SELINUX=enforcing/SELINUX=disable/g' /etc/selinux/config
reboot
