# summary

## GitLab 的优势和应用场景

- 开源免费，适合中小型企业公司将代码放置在该系统中。

- 差异化的版本管理，离线同步以及强大的分支管理功能。

- 便捷的 GUI 操作界面以及强大的账户权限管理功能。

- 集成度很高，能够集成绝大多数的开发工具。

- 支持内置 HA ，保证在高并发下仍旧实现高可用性。

## GitLab 的主要服务构成

- Nginx 静态 Web 服务器。

- GitLab-workhorse 轻量级的反向代理服务器。

- GitLab-shell 用于处理 Git 命令和修改 authorized keys 列表。

- Logrotate 日志文件管理工具。

- Postgresql 数据库。

- Redis 缓存服务器。

## GitLab 的工作流程

- 创建并克隆项目。

- 创建项目某 Feathure 分支。

- 编写代码提交到该分支。

- 推送该项目分支值远程 GitLab 服务器。

- 进行代码检查并提交 Master 主分支合并申请。

- 项目领导审查代码并确认合并申请。

## GitLab 的安装配置管理

### Omnibus Gitlab-ce package

