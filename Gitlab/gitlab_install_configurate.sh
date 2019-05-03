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

gitlab_ssl=/etc/gitlab/ssl.d
gitlab_key=${gitlab_ssl}/gitlab.gysl.com.key
gitlab_csr=${gitlab_ssl}/gitlab.gysl.com.csr
gitlab_crt=${gitlab_ssl}/gitlab.gysl.com.crt
gitlab_pem=${gitlab_ssl}/dhparams.pem

mkdir -p ${gitlab_ssl}

# Omnibus GitLab-ce package
# We can see: https://about.gitlab.com/install/#centos-7 or https://about.gitlab.com/install
# And you can also execute gitlab_ce_rpm.sh.
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
# Install gitlab-ce.
yum -y install policycoreutils gitlab-ce
echo "GitLab-ce had been installed in your system. Please check them. "
sleep 10

# Make SSL certificates.
cd ${gitlab_ssl}
openssl genrsa -out ${gitlab_key} 2048
openssl req -new -key ${gitlab_key} -out ${gitlab_csr}
openssl x509 -req -days 365 -in ${gitlab_csr} -signkey ${gitlab_key} -out ${gitlab_crt}
openssl dhparam -out ${gitlab_pem} 2048
chmod 600 *
ls -l
echo "The certificates had been created. Please check them."
sleep 10
