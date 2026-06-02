<!--
把以下片段追加到你工作区的 AGENTS.md（Codex / 通用 agent 协议文件），
放在「工具与命令约定」一类的章节里，避开任何 mirror / 同步块。
作用：让 Codex 读协议时知道 GTD harness 的存在，"说人话即触发"。
-->

### GTD harness（个人任务系统）

用户提到 GTD / 任务 / 收集 / 理清 / 下一步行动 / 每周回顾 / 清空大脑 / 「这周做什么」时，加载 GTD harness：

- **直读真源**：`rtk cat .cursor/skills/gtd-harness/SKILL.md`（包导航），再按意图 `rtk cat` 对应子命令（init/capture/clarify/organize/engage/review）。
- **自主链式**：spawn `gtd-orchestrator` agent（`.codex/agents/gtd-orchestrator.toml`）跑完整流程。
- **状态**：可信清单在 `memory/gtd/`（八清单，纯 markdown）；`rtk bash .cursor/skills/gtd-harness/scripts/gtd_status.sh` 看全景；首次 `… /gtd_init.sh`。
- **边界**：个人任务系统；日历写入需显式确认（见包内 `references/capability-map.md`）。
