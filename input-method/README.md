# Rime / Squirrel

`rime/` 保存可公开、可迁移的输入法配置：方案 YAML、Squirrel 外观、Lua 脚本、符号表和小型辅助词典。

## 个性化主题

`rime/squirrel.custom.yaml` 内置两套个人 Catppuccin 风格主题，并跟随 macOS 外观自动切换：

- `zhaoyi_latte`：浅色模式；
- `zhaoyi_mocha`：深色模式。

两套主题均使用横向候选栏、苹方 16pt、8px 圆角，并保留较宽松的候选词与上下间距。

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
