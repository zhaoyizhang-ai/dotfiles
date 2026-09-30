# Clash Verge 分流

当前方案：开启系统代理，混合端口 `7897`，使用规则模式，关闭 TUN。内网、北大网站和国内流量直连；海外流量使用当前订阅的代理组。`pku-ics.com` 单独直连，解决 Autolab 被海外节点转发后连接超时的问题。

## 恢复

1. 安装并打开 Clash Verge，导入自己的订阅，选中要使用的订阅。`software/Brewfile` 已包含应用，也可以通过 [Homebrew 官方 cask](https://formulae.brew.sh/cask/clash-verge-rev) 安装：`brew install --cask clash-verge-rev`。
2. 在仓库根目录运行：

```bash
ruby scripts/clash-routing.rb restore
```

脚本读取当前订阅的标识和规则覆盖文件，不依赖本机的 UID。`rules.yaml` 中的 `__PROXY_GROUP__` 自动替换为当前有效 `MATCH` 规则的目标，因此 MistyCloud 和 GLaDOS 可以沿用同一份分流策略。已有的其他覆盖规则保留在新规则之后。

脚本先备份到 `~/.dotfiles-restore-backup/<时间戳>/clash-verge/`。Clash Verge 正在运行时，候选配置通过 Mihomo 检查后再写入并热加载；未运行时，下次启动应用生效。恢复前后继续使用同一订阅和节点。首次导入订阅以后再恢复；`install.sh` 会在已有订阅时调用这个脚本。

若应用正在运行且这次恢复更改了系统代理开关或端口，请退出并重新打开 Clash Verge，让应用重新应用系统网络设置。当前 Mac 的系统代理已经开启并使用 `7897`，恢复不会切换入口。

## 更新备份

```bash
ruby scripts/clash-routing.rb export
./scripts/scan-secrets.py
git diff -- apps/clash-verge
```

`sync-from-home.py` 同样调用上述导出。只导出当前订阅的前置路由规则，以及端口、模式、IPv6、日志级别、局域网访问、系统代理、TUN 与自动启动等白名单设置。订阅 URL、账户、节点服务器/密码、控制接口凭据、缓存、会话和日志均留在本机。更换订阅后运行恢复命令，把这套规则应用到新订阅；订阅更新保留独立覆盖文件。

## 验证

以下请求明确经过本地代理，验证分流能在系统代理开启时正常工作：

```bash
curl --noproxy '' -x http://127.0.0.1:7897 -L -o /dev/null -w '%{http_code}\n' https://autolab.pku-ics.com/
curl --noproxy '' -x http://127.0.0.1:7897 -o /dev/null -w '%{http_code}\n' https://www.baidu.com/
curl --noproxy '' -x http://127.0.0.1:7897 -o /dev/null -w '%{http_code}\n' https://www.google.com/generate_204
```

2026-09-30 在当前 Mac 验证：Autolab 登录页 `200`、百度 `200`、Google `204`；Mihomo 记录的路径分别为北大域名直连、国内直连、Misty 节点。校外访问北大内网站点仍需要可达的校园网或北大 VPN。

扩展机制参考 [Clash Verge 官方文档](https://www.clashverge.dev/guide/extend.html)。
