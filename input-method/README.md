# Rime / Squirrel

`rime/` 保存可公开、可迁移的输入法配置：方案 YAML、Squirrel 外观、Lua 脚本、符号表和小型辅助词典。

## 恢复顺序

1. 安装 [Squirrel](https://rime.im/download/)。
2. 安装上游主词库 [iDvel/rime-ice](https://github.com/iDvel/rime-ice)。
3. 在仓库根目录运行 `./install.sh`，把这里的个人配置覆盖到 `~/Library/Rime/`。
4. 从 Squirrel 菜单选择“重新部署”。

## 隐私边界

以下文件不会进入公开仓库：

- `installation.yaml`：设备安装 ID 和时间；
- `user.yaml`：最近使用方案等运行状态；
- `custom_phrase.txt`：个人短语；
- `*.userdb/`：用户词频和学习记录；
- `sync/`、`build/`：同步数据和编译产物；
- `cn_dicts/`、`en_dicts/`、`opencc/`：可从 Rime Ice 重新获取的上游大词库。
