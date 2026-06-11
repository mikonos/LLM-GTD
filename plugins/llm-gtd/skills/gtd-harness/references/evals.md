# GTD Skill Evals

> 轻量人工 eval。改动 GTD skill 前后，用这些场景检查触发、路由、边界和隐私是否回归。每条 eval 都应能从当前 skill 文档推出稳定行为。

## 运行方式

1. 逐条把「输入」当作用户请求。
2. 对照「期望路由 / 必须 / 禁止」判断 pass/fail。
3. 改动 skill 后至少跑本文件 14 条核心 eval；做 public sync 前必须全过。
4. 静态门禁可跑：`bash scripts/gtd_eval_check.sh`（在 skill 根内）或 `GTD_SKILL_ROOT=src/skill bash src/skill/scripts/gtd_eval_check.sh`。

## 初始人工跑通记录

- 2026-06-11：E01-E14 已按当前入口路由、子 skill 顶部加载表、`list-definitions.md` 权限表人工审阅，结果 14/14 pass。静态门禁 `gtd_eval_check.sh` 也已通过。

## 核心 Evals

| ID | 输入 | 期望路由 | 必须 | 禁止 |
|---|---|---|---|---|
| E01-trigger | “我脑子太乱，帮我清空一下 GTD” | `capture/SKILL.md` | 进入 mind sweep；先全捕捉，再问是否批量 clarify | 直接做 weekly review；逐条打断 |
| E02-non-trigger | “这篇文章帮我写成一张知识卡” | ZK 管线，不触发 GTD action | 说明这是知识/想法处理，应走 fleeting-note / ZK | 写入 next-actions |
| E03-capture-single | “记一下：给同事 A 确认合同版本” | `capture` → `clarify` | 先落 inbox；少量输入默认自动理清；输出一行去向 | 只停在 inbox 不处理；要求用户选择子命令 |
| E04-mind-sweep | “买牛奶；回邮件；准备周五会议；研究一个产品点子” | `capture/SKILL.md` | 多条先全捕捉；再批量 clarify；产品点子进 product-ideas 并给可见下一步 | 每条都单独问确认 |
| E05-product-idea | “做一个自动整理家庭采购清单的功能想法” | `clarify/SKILL.md` | 进 `product-ideas.md`；同时默认创建 project / next-action 可见性 | 丢进 someday 当冷藏 backlog |
| E06-waiting-final | “某项审批已经通过了” | `clarify/SKILL.md` | 追问或记录最终完成口径；区分 approval passed 与到账/最终完成 | 直接删除 waiting-for 当完成 |
| E07-ten-min | “我只有 10 分钟，现在做什么？” | `engage/SKILL.md` | 先看 hard landscape；从行动池给 3-5 条短候选，并说明为什么现在能做 | 推荐深工作任务；把候选排进日历 |
| E08-low-energy | “我没电了，只想做轻的” | `engage/SKILL.md` | 用低精力镜头；排除高认知负担任务 | 推荐高压沟通或深工作 |
| E09-shopping-prep | “我在采购 / 明早要准备什么？” | `engage/SKILL.md` | 使用采购或准备链硬情境筛选；旧 @ 分组只做兼容信号 | 因 @电脑 分组默认推荐 |
| E10-review | “帮我做每周回顾” | `review/SKILL.md` | 先跑预回顾包；Get Clear / Current / Creative；给下周 3 件候选 | 自动砍项目、发消息、写日历 |
| E11-init-status | “检查一下 GTD 初始化状态” | `init/SKILL.md` | 跑 `gtd_init.sh --status`；只读报告现状 | 创建或修改 automation |
| E12-install-cron | “初始化 GTD cron” | `init/SKILL.md` + `automation-profiles.md` | 先读 profiles；显式安装才调用平台 automation 工具；装后跑 status 验证 | shell 手写 automation 文件；重复创建同类 cron |
| E13-privacy | “公开同步这个 skill 前检查隐私” | `references/evals.md` + 隐私扫描 | 使用私有 overlay 或外部环境提供的 denylist 扫描；真实 provider 偏好只应在 private overlay | 通用 skill 内出现真实人名、真实项目名、本地路径 |
| E14-update-reality | “做完了 / 对方回了 / 日程改了 / 取消了” | `update/SKILL.md` | 读取既有清单后同步现实变化；完成项删除，waiting-for 回应重新理清，项目必要时推进下一步 | 把现实变化重新 capture 成 inbox |

## 自动检查项

```bash
bash scripts/gtd_eval_check.sh
bash -n scripts/gtd_init.sh
bash -n scripts/gtd_env.sh
bash -n scripts/gtd_status.sh
bash -n scripts/gtd_review_prep.sh
bash -n scripts/gtd_review_prep_notify.sh
LLM_GTD_ROOT="$(mktemp -d)" bash scripts/gtd_init.sh --status
```

隐私 denylist 不写入本文件；由私有 overlay 或运行时环境提供，避免通用 skill 自身携带私人词。
