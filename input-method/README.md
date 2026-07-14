# Rime / Squirrel

`rime/` 保存当前可直接部署的完整输入法配置：方案 YAML、Squirrel 外观、Lua、符号表、Rime Ice 主词库和个人短语。

## 恢复顺序

在新 Mac 上克隆仓库后执行：

```bash
./scripts/restore-rime.sh
```

脚本会自动完成：

1. 通过 Homebrew 安装 Squirrel 1.1.2（未安装时）；
2. 把目标机原有 `~/Library/Rime` 保存到 `~/.dotfiles-restore-backup/<时间戳>/`；
3. 恢复当前方案、`mojave_dark` 外观、Lua、完整词库和 `custom_phrase.txt`；
4. 保留目标机生成的安装 ID、运行状态和用户词频数据库；
5. 重新部署并验证当前主题。

## 隐私边界

以下文件不会进入公开仓库：

- `installation.yaml`：设备安装 ID 和时间；
- `user.yaml`：最近使用方案等运行状态；
- `*.userdb/`：用户词频和学习记录；
- `sync/`、`build/`：同步数据和编译产物；

`custom_phrase.txt` 已纳入备份，以保证恢复结果与当前配置一致；提交前会额外扫描邮箱、手机号、身份证、银行卡样式数字、URL、Token、私钥和敏感字段。Rime Ice 来源为 [iDvel/rime-ice](https://github.com/iDvel/rime-ice)。
