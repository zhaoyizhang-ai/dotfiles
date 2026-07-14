# rcmd

`preferences.plist` 保存当前 rcmd 的稳定配置：App/窗口快捷键、切换行为、搜索规则和 OSD 外观。

## 恢复

```bash
./scripts/restore-rcmd.sh
```

脚本会在需要时通过 Homebrew 安装 rcmd，把目标机现有偏好备份到 `~/.dotfiles-restore-backup/<时间戳>/rcmd/`，然后只合并公开配置键并重新启动 rcmd。

## 不进入仓库

- Paddle 授权数据及 `Application Support/rcmd`；
- Sentry 用户/设备 ID；
- 最近关闭窗口、已扫描应用清单和搜索选择历史；
- 窗口位置、更新记录、启动次数和权限提示状态。

恢复不会覆盖目标机上的授权和运行状态。辅助功能权限属于 macOS 隐私授权，需要在新电脑上手动允许。
