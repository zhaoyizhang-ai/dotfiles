# Skill 来源与权威性登记表

最后核验：2026-07-13

这份登记表记录当前个人技能的两个来源维度：

- **获取来源**：这个技能通过谁或什么渠道来到本机。
- **上游来源**：技能内容最初来自哪个仓库、组织或本地工作流。

获取来源和上游来源必须分开记录。学长学姐提供的技能即使上游也是 GitHub，仍按“学长学姐来源”评级。

## 权威等级

| 等级 | 含义 | 使用规则 |
|---|---|---|
| S | 学长学姐明确提供或背书 | 研究判断中的最高优先级。不得仅因网上技能更新或热度更高就覆盖；应并存比较并保留原版。 |
| A | 官方工具技能，或用户与 Codex 共同建立并反复验证的本地技能 | 工具操作或用户个人工作流中高可信。 |
| B | 有明确机构、实验室或学术团队身份的公开技能 | 可采用，但研究判断低于 S 级来源。 |
| C | 普通公开网络仓库或个人作者技能 | 作为方法参考，需要结合实际任务验证。 |
| U | 来源尚未确认 | 不猜测权威性；待用户确认后升级。 |

权威等级表示**来源可信度**，不自动证明所有内容正确。论文事实、代码能力和时效性信息仍须查证第一手来源。

## S 级：学长学姐来源

| Skill | 获取来源 | 上游来源 | 适用领域 | 证据 |
|---|---|---|---|---|
| `deep-research-framework` | **fst学姐版本** | 本地原件 `__HOME__/Desktop/fst项目/Claude-Deep-Research-Framework-main`；其 README 标明上游为 [Physis-AI/Claude-Deep-Research-Framework](https://github.com/Physis-AI/Claude-Deep-Research-Framework)，并基于 [danielrosehill/Claude-Deep-Research-Template](https://github.com/danielrosehill/Claude-Deep-Research-Template) | 深度研究、文献锚定 brainstorming、idea critique | 用户于 2026-07-13 明确指定“记录为 fst学姐版本”；Codex skill 保留了原框架映射和完整资产。 |
| `paper-deepread` | **zjy学长版本** | 由本地 `paper_deep` 包迁移；早期原件内容包含 `/Users/zhoujiayi/...` 路径，公开上游尚未确认 | 论文精读、技术细节、实验证据、复现档案 | 用户于 2026-07-13 明确指定显示来源名为“zjy学长”。当前版本已针对 ResearchNotes 与 VLA+WM 项目适配。 |

## A 级：官方工具或用户验证的本地技能

| Skill | 获取来源 | 上游来源 | 说明 |
|---|---|---|---|
| `playwright` | 官方 CLI 安装生成 | [Microsoft Playwright](https://github.com/microsoft/playwright) CLI 的 `install --skills` 工作流 | 浏览器自动化工具技能。 |
| `explain` | 用户与 Codex 多轮共同打磨 | 本机自定义 | 已按用户的“先易懂后严谨、完整因果链、来源覆盖”要求反复修订。 |
| `wm-paper-incubation` | 用户与 Codex 多轮共同打磨 | 本机自定义 | 面向用户的一作 acWM / video-WM 研究方向。 |
| `paper-quickread` | 用户与 Codex 创建并审阅 | 本机自定义 | 第一手 PDF 驱动的中文论文阅读笔记。 |
| `dialogue-to-learning-note` | 用户与 Codex创建 | 本机自定义 | 将先对话理解的内容整理为中文学习笔记。 |
| `progress-read` | 用户与 Codex 创建 | 本机自定义 | 读取项目 `progress.md` 交接。 |
| `progress-update` | 用户与 Codex 创建 | 本机自定义 | 更新紧凑项目交接记录。 |
| `install-skill-codex-claude` | 用户与 Codex 创建 | 本机自定义 | 同时为 Codex 与 Claude Code 安装第三方技能。 |

## B 级：机构或学术团队公开来源

### HKUSTDial / Supervisor-Skills

获取来源：2026-07-13 从公开 GitHub 仓库 [HKUSTDial/Supervisor-Skills](https://github.com/HKUSTDial/Supervisor-Skills) 安装。上游来自香港科技大学（广州）DIAL 团队。属于公开网络学术团队来源，低于明确的学长学姐 S 级来源。

| Skill |
|---|
| `benchmark-paper-template` |
| `deep-research` |
| `figure-designer` |
| `idea-evaluator` |
| `paper-polish` |
| `paper-writer` |
| `pre-submission-reviewer` |
| `tech-paper-template` |

### Asta

| Skill | 获取来源 | 上游来源 | 说明 |
|---|---|---|---|
| `asta-skill` | 公开 GitHub 安装 | 技能包装来自 [Agents365-ai/asta-skill](https://github.com/Agents365-ai/asta-skill)；底层学术语料工具来自 [Ai2 Asta](https://asta.allen.ai/) / Semantic Scholar | 技能包装本身是公开第三方，底层数据服务具有明确机构来源。 |

## C 级：普通公开网络来源

### lingzhi227 / agent-research-skills

以下技能来自公开仓库 [lingzhi227/agent-research-skills](https://github.com/lingzhi227/agent-research-skills)。该套件于 2026-05-19 作为一整套研究流水线安装；它有可用脚本和模板，但没有学长学姐背书，研究判断权威性低于 S 级和 B 级。

| Skill | Skill | Skill |
|---|---|---|
| `algorithm-design` | `atomic-decomposition` | `backward-traceability` |
| `citation-management` | `data-analysis` | `experiment-code` |
| `experiment-design` | `figure-generation` | `github-research` |
| `idea-generation` | `latex-formatting` | `literature-search` |
| `math-reasoning` | `novelty-assessment` | `paper-compilation` |
| `paper-revision` | `rebuttal-writing` | `research-planning` |
| `slide-generation` | `symbolic-equation` | `table-generation` |

### mattpocock / skills 系列

以下技能来自或基于公开仓库 [mattpocock/skills](https://github.com/mattpocock/skills) 的工程工作流；本机版本可能早于当前上游，因此以本机内容为准，并在需要更新时重新比对。

| Skill |
|---|
| `diagnose` |
| `tdd` |
| `zoom-out` |
| `grill-me` |
| `grill-with-docs` |

## 维护规则

1. 新安装技能时，必须同步登记获取来源、上游仓库、安装日期和权威等级。
2. 用户明确说某技能来自学长学姐时，直接记录为 S，并保留用户给出的称呼，例如“fst学姐版本”。
3. 不把“GitHub star 多”“作者自称专家”自动视为高权威。
4. 替换 S 级技能前必须先比较并征得用户明确同意；默认保留原版。
5. 来源不确定时使用 U，不根据用户名、目录名或内容风格猜测。
6. 系统内置与插件技能的来源由其命名空间和安装清单管理；不要修改插件缓存来添加来源字段。

## 系统与插件技能

这些技能不计入上面的 45 个个人技能，因为它们由 Codex 自动提供和更新：

| 路径或命名空间 | 来源等级 | 来源 |
|---|---|---|
| `~/.codex/skills/.system/*` | A | OpenAI Codex 系统内置技能。 |
| `~/.codex/plugins/cache/openai-bundled/*` | A | OpenAI bundled plugins。 |
| `~/.codex/plugins/cache/openai-primary-runtime/*` | A | OpenAI primary runtime，包括 documents、PDF、slides、spreadsheets 等。 |
| `~/.codex/plugins/cache/openai-curated-*/*` | A/B | OpenAI curated plugin；具体领域内容仍按其上游作者和第一手来源评估。 |
