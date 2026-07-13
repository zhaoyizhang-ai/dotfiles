---
name: explain-model
description: Explain an ML/AI model with structured coverage of design intuition, key insights, I/O format, data, and training procedure
---

<command-name>explain-model</command-name>

When this skill is invoked, explain the specified model (or the model currently under discussion) using **exactly this structure**, in the same language the user is using:

---

## 1. 设计直觉 (Design Intuition)
用一两句话说清楚：这个模型是为了解决什么问题而设计的，作者的核心出发点是什么。避免堆砌术语，用类比或对比前人方法来建立直觉。

## 2. 核心 Insight
列出 2–4 条关键洞察——这个模型"聪明在哪里"。每条用一句话点出，再用一两句解释为什么这个 insight 有效或非显而易见。

## 3. 输入 (Inputs)
精确描述输入的格式，具体到张量维度、数据对符号，例如：
- `(s_t, a_t)` — 当前状态与动作
- `o_t ∈ ℝ^{H×W×C}` — RGB 图像观测
- `τ = {(s_0,a_0), ..., (s_T,a_T)}` — 轨迹序列

列出每个输入变量的含义、类型、典型取值范围（如果重要）。

## 4. 输出 (Outputs)
同样精确描述输出格式与符号，例如：
- `π(a|s)` — 动作概率分布
- `Q(s,a) ∈ ℝ` — 标量 Q 值
- `ẑ_t ∈ ℝ^d` — 潜表示向量

说明输出的物理/统计意义。

## 5. 数据 (Data)
- 数据来源：离线数据集 / 在线交互 / 合成数据 / 人类标注
- 数据结构：单��样本长什么样（用具体符号）
- 数据规模的典型量级（如果已知）
- 数据的特殊要求或假设（e.g., i.i.d.、Markov、多模态对齐）

## 6. 训练方式 (Training)
- 损失函数（写出公式或近似形式）
- 优化目标（最大化/最小化什么）
- 训练范式：监督学习 / 强化学习 / 自监督 / 对比学习 / …
- 关键训练技巧：目标网络、经验回放、课程学习、数据增强等
- 计算资源量级（如果已知）

---

After the structured explanation, add a one-paragraph **直觉总结 (TL;DR)** that ties everything together in plain language — what makes this model work, and what its main limitation or open question is.

If the user has not specified a model, ask: "你想让我解释哪个模型？"
