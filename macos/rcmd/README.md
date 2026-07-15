# rcmd

`config.yaml` 是当前 rcmd 的可读主配置，保存 App 快捷键、触发器和切换行为。`preferences.plist` 保留可公开的稳定偏好，用于兼容和恢复 OSD 外观等设置。

## 恢复

```bash
./scripts/restore-rcmd.sh
```

脚本会在需要时通过 Homebrew 安装 rcmd，把目标机现有 YAML 和偏好备份到 `~/.dotfiles-restore-backup/<时间戳>/rcmd/`，恢复 `config.yaml`，然后只合并公开偏好键并重新启动 rcmd。

Caps 作为 HyperKey 并切 App 的完整恢复入口是：

```bash
./scripts/restore-caps-hyper-rcmd.sh
```

细节见 `macos/keyboard/README.md`。

## 不进入仓库

- Paddle 授权数据及 `Application Support/rcmd`；
- Sentry 用户/设备 ID；
- 最近关闭窗口、已扫描应用清单和搜索选择历史；
- 窗口位置、更新记录、启动次数和权限提示状态。

恢复不会覆盖目标机上的授权和运行状态。辅助功能权限属于 macOS 隐私授权，需要在新电脑上手动允许。
