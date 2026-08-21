# Caps Lock：无大小写、无输入法切换、快速切 App

目标：Caps Lock 不再控制大小写、不亮灯、不切换输入法；按住 Caps 再按字母，通过 rcmd 直接切到固定 App。

## 当前工作链

1. macOS `hidutil` 把系统看到的 Caps Lock 映射成无害的 `F18`。
2. HyperKey 从原始 HID 键盘事件读取物理 Caps，并生成左侧 `Cmd+Option+Control+Shift`。
3. rcmd 使用 `[lcmd, lalt, lctrl, lshift]` 作为 App 切换触发器。
4. 登录脚本固定按 `rcmd -> 等待 2 秒 -> HyperKey` 的顺序启动。

`hidutil` 映射本身在重启后会消失，所以由 `com.az.caps-hyper-rcmd` LaunchAgent 在每次登录时重新应用。它是一个很小的系统脚本，不是第三个常驻 App。

## 当前按键

| 按键 | App |
| --- | --- |
| Caps+F | Google Chrome |
| Caps+D | Zotero |
| Caps+S | ChatGPT/Codex |
| Caps+G | Obsidian |
| Caps+R | Finder |
| Caps+V | Visual Studio Code |
| Caps+E | Safari |
| Caps+W | Preview |
| Caps+M | Music |
| Caps+T | iTerm2 |
| Caps+P | PowerPoint |

完整映射在 `macos/rcmd/config.yaml`。

## 恢复

```bash
./scripts/restore-caps-hyper-rcmd.sh
```

脚本会：

- 安装/恢复 rcmd；
- 从官方 GitHub Release 安装固定版本、固定 SHA256 且通过 Apple 公证检查的 HyperKey；
- 恢复 rcmd YAML 与公开偏好；
- 安装登录脚本并立即应用 Caps→F18 映射；
- 安装 `~/.local/bin/rcmd-restart` 快速重启命令；
- 按已验证的顺序重启 rcmd 和 HyperKey。

随后必须在“系统设置 → 隐私与安全性”手动授权：

- 辅助功能：HyperKey、rcmd；
- 输入监控：HyperKey。

授权后执行：

```bash
~/.local/bin/caps-hyper-rcmd
```

日常快速重启：

```bash
~/.local/bin/rcmd-restart
```

## 验证

```bash
hidutil property --get UserKeyMapping
pgrep -fl '/Applications/(rcmd|HyperKey)\.app'
```

然后验证：单按 Caps 不亮灯、不切大小写、不切输入法；`Caps+F` 切 Chrome，`Caps+D` 切 Zotero，`Caps+P` 切 PowerPoint，`Caps+T` 切 iTerm2。

## 关键约束

- 不要把 rcmd 触发器改成通用 `cmd/alt/ctrl/shift`；当前 HyperKey 实际发送四个左修饰键。
- 不要交换启动顺序；rcmd 必须先启动，HyperKey 后启动。
- 不要删除 Caps→F18 映射；只靠 HyperKey 时，macOS 仍可能切换大小写。
- 不要备份 rcmd 的 Paddle 授权、运行历史或 macOS 的 TCC 权限数据库。
