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
gitlab_domain=gitlab.gysl.com
gitlab_key=${gitlab_ssl}/${gitlab_domain}.key
gitlab_csr=${gitlab_ssl}/${gitlab_domain}.csr
gitlab_crt=${gitlab_ssl}/${gitlab_domain}.crt
gitlab_pem=${gitlab_ssl}/dhparams.pem

[ -d ${gitlab_ssl} ] && rm -rf ${gitlab_ssl} 
[ ! -d ${gitlab_ssl} ] && mkdir -p ${gitlab_ssl}

# Omnibus GitLab-ce package
# We can see: https://about.gitlab.com/install/#centos-7 or https://about.gitlab.com/install
# And you can also execute gitlab_ce_rpm.sh.
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash
# Install gitlab-ce.
yum -y install policycoreutils gitlab-ce
if [ $? -eq ];then
  echo "GitLab-ce had been installed in your system. Congratulations! "
  sleep 10
else
  echo "Installation failed. Please check! "
  exit 127

# Make SSL certificates.
cd ${gitlab_ssl}
openssl genrsa -out ${gitlab_key} 2048
openssl req -new -key ${gitlab_key} -out ${gitlab_csr}
openssl x509 -req -days 365 -in ${gitlab_csr} -signkey ${gitlab_key} -out ${gitlab_crt}
openssl dhparam -out ${gitlab_pem} 2048
chmod 600 *
echo "The certificates had been created. Please check them."
ls -l ${gitlab_ssl}/*
sleep 10

# Modify configuration. We can learn more: https://docs.gitlab.com/omnibus/settings/nginx.html
sed -i.bak "s#external_url 'http://gitlab.example.com'#external_url 'https://${gitlab_domain}'#g" /etc/gitlab/gitlab.rb
sed -i "s/# nginx\['redirect_http_to_https'\] = false/nginx\['redirect_http_to_https'\] = true/g" /etc/gitlab/gitlab.rb
sed -i "s%/etc/gitlab/ssl/#{node\['fqdn'\]}\.crt%${gitlab_crt}%g" /etc/gitlab/gitlab.rb
sed -i "s%/etc/gitlab/ssl/#{node\['fqdn'\]}\.key%${gitlab_key}%g" /etc/gitlab/gitlab.rb
sed -i "s%# nginx\['ssl_dhparam'\] = nil%# nginx\['ssl_dhparam'\] = ${gitlab_pem}%g" /etc/gitlab/gitlab.rb
echo "The revised content is as follow. Please check!"
grep -v ^# /etc/gitlab/gitlab.rb|sed '/^$/d'
grep -e "'ssl_certificate'] =" -e "ssl_certificate_key']" -e "'ssl_dhparam'] =" /etc/gitlab/gitlab.rb
sleep 10

# GitLab-ctl reconfigure
gitlab-ctl reconfigure