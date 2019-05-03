# summary

## 一 GitLab 的优势和应用场景

- 开源免费，适合中小型企业公司将代码放置在该系统中。

- 差异化的版本管理，离线同步以及强大的分支管理功能。

- 便捷的 GUI 操作界面以及强大的账户权限管理功能。

- 集成度很高，能够集成绝大多数的开发工具。

- 支持内置 HA ，保证在高并发下仍旧实现高可用性。

## 二 GitLab 的主要服务构成

- Nginx 静态 Web 服务器。

- GitLab-workhorse 轻量级的反向代理服务器。

- GitLab-shell 用于处理 Git 命令和修改 authorized keys 列表。

- Logrotate 日志文件管理工具。

- Postgresql 数据库。

- Redis 缓存服务器。

## 三 GitLab 的工作流程

- 创建并克隆项目。

- 创建项目某 Feathure 分支。

- 编写代码提交到该分支。

- 推送该项目分支值远程 GitLab 服务器。

- 进行代码检查并提交 Master 主分支合并申请。

- 项目领导审查代码并确认合并申请。

## 四 GitLab(Omnibus Gitlab-ce package) 的安装配置管理

### 4.1 初始化安装环境(CentOS-1810)

关闭 SELinux 和防火墙或添加防火墙策略，重启系统。本实践操作过程中，关闭了防火墙。添加防火墙策略命令如下：

```bash
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```

### 4.2 Omnibus GitLab 等相关配置初始化并完成安装

- 证书创建与配置加载。

```bash
openssl genrsa -out ${gitlab_key} 2048
openssl req -new -key ${gitlab_key} -out ${gitlab_csr}
```

填写示例：

```txt
Country Name (2 letter code) [XX]:cn
State or Province Name (full name) []:bj
Locality Name (eg, city) [Default City]:bj
Organization Name (eg, company) [Default Company Ltd]:
Organizational Unit Name (eg, section) []:gysl
Common Name (eg, your name or your server's hostname) []:gitlab.gysl.com
Email Address []:mrivandu@hotmail.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:123456
An optional company name []:
```

```bash


- Nginx SSL 代理服务配置。

- 初始化 GitLab 相关的服务并完成安装。


## 参考资料

[官方文档](https://docs.gitlab.com/ce/README.html)