---
name: log-experiment
description: After an experiment run completes, write a structured Markdown log on the baidu server. Records time, background, process, results, and code paths. Must be called after every experiment.
argument-hint: "[run_name] [out_dir_on_server]"
allowed-tools: Read, Write, Edit, Bash(ssh *), Bash(scp *), Bash(cat *), Bash(tail *)
metadata:
  category: experiment
  tags: [logging, experiment, server, baidu, record]
  triggers:
    - log experiment
    - 记录实验
    - 实验记录
    - write run log
    - experiment done
---

# Log Experiment

Write a structured experiment log on the baidu server after a run completes.

## When to use

Call this skill **immediately after every experiment run finishes** — whether success, failure, or partial result. This is mandatory per project rules in CLAUDE.md and AGENTS.md.

## Input

- `$ARGS` — run name and/or server output directory, e.g. `irasim_droid_first_window /mnt/pfs/users/zhaoyi/outputs/irasim_droid_first_window`

## ⚠️ 路径规则（2026-06-12 更新）

**所有实验产物必须放在 `experiments/runs/` 下，不要用 `outputs/`。**

- 本地：`experiments/runs/<run_name>/`
- 服务器：`/mnt/pfs/users/zhaoyi/outputs/<run_name>/`（服务器端路径不变）
- manifest 等跨实验汇总文件：`experiments/runs/manifest_*.jsonl`
- 视频、run_log、config 副本等实验产物：全部在 `experiments/runs/<run_name>/` 内

## Process

Follow these steps exactly:

### Step 1 — Gather information

Collect all of the following from the conversation context and by reading server files:

1. **时间**: Current date and time (use `date` on server via `ssh baidu "date"`)
2. **实验背景**:
   - What hypothesis or question was being tested
   - What model/dataset was used
   - State before the experiment (what was missing, what was broken)
3. **实验过程**:
   - Exact commands run (with full paths and flags)
   - Any bugs encountered and how they were fixed
   - Key parameters (GPU, batch size, num_frames, checkpoint, etc.)
4. **实验结果**:
   - Read `results.json` from the output dir if it exists
   - Copy key metrics (PSNR per episode, mean success vs failure, delta)
   - Interpret: does the result support or contradict the hypothesis?
5. **相关代码及路径**:
   - Inference/training script (full server path)
   - Config files used (full server path)
   - Data annotation directory (full server path)
   - Checkpoint used (full server path)

### Step 2 — Write the log on the server

**Do NOT use heredoc over SSH** (shell escaping breaks). Instead:
1. Write the log to a local temp file with the Write tool
2. SCP it to the server
3. Verify

```bash
# Write locally first
Write tool -> /tmp/<run_name>_run_log.md

# SCP to server
scp -P 4997 -i __HOME__/Desktop/SSH-WM/baidu_machine/id_ed25519 \
    /tmp/<run_name>_run_log.md \
    zhaoyi@114.111.19.170:/mnt/pfs/users/zhaoyi/outputs/<run_name>/run_log.md
```

The log must be at: `/mnt/pfs/users/zhaoyi/outputs/<run_name>/run_log.md`

**Dual recording is mandatory**: every log must exist on BOTH the server AND locally:
- Server: `/mnt/pfs/users/zhaoyi/outputs/<run_name>/run_log.md`
- Local: `experiments/runs/<run_name>/run_log.md` (under the project root)

If the local `experiments/runs/<run_name>/` directory doesn't exist yet, create it first.

### Step 3 — Verify

```bash
ssh baidu "head -5 /mnt/pfs/users/zhaoyi/outputs/<run_name>/run_log.md"
ls experiments/runs/<run_name>/run_log.md
```

Confirm both files exist and are non-empty.

## Log template

```markdown
# 实验记录：<run_name>

## 时间
<date and time>

## 实验背景
**目标：** <what hypothesis is being tested>
**模型：** <model name and checkpoint>
**数据集：** <dataset name, number of pairs, tasks>
**实验前状态：** <what was the situation before — e.g. missing dependency, prior results>

## 实验过程
**启动命令：**
\`\`\`bash
<exact command used>
\`\`\`

**关键参数：**
- GPU: <which GPU>
- num_frames: <value>
- checkpoint: <path>
- val_start_frame_interval: <value>

**遇到的问题及修复：**
<list ALL bugs encountered, root cause analysis, and how each was fixed. Be specific:>
- Bug: <what went wrong>
  - 根本原因: <why it happened>
  - 修复: <exact fix applied, file changed, line changed>

## 实验结果
**各 episode PSNR：**
| episode_id | is_success | PSNR |
|------------|------------|------|
<fill from results.json>

**汇总：**
- Success 平均 PSNR: <value> ± <std>
- Failure 平均 PSNR: <value> ± <std>
- Delta (S-F): <value>

**结论：** <does success PSNR > failure PSNR? consistent with hypothesis?>

**问题分析（如果结果不理想）：**
<If generation quality is poor or results are inconclusive, analyze WHY:>
- 生成质量评估: <visual quality of generated videos — stable/distorted/collapsed>
- 失败原因分析: <root cause — domain gap? wrong action format? model limitation?>
- 证据: <what specific observations support this diagnosis>
- 建议: <next steps or alternative approaches>

## 相关代码及路径
| 用途 | 路径 |
|------|------|
| 推理脚本 | <full path> |
| 配置文件 | <full path> |
| 数据 annotation | <full path> |
| 模型 checkpoint | <full path> |
| 输出目录（服务器） | <full path> |
| 输出目录（本地） | <full path> |
```
