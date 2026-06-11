#!/usr/bin/env bash
# gtd_init.sh — 幂等搭建 GTD 可信系统（memory/gtd/ 核心八清单 + 产品想法扩展清单）+ 自检适配层 + 自动节律只读检查
#
# 用法：
#   bash gtd_init.sh                 # 幂等建核心八清单 + 产品想法扩展清单 + 自检 + 自动节律只读检查（已存在的不覆盖）
#   bash gtd_init.sh --import-legacy # 额外：一次性从旧 memory/open loops.md 导入（旧文件不改）
#   bash gtd_init.sh --status        # 只做自检、自动节律只读检查与就绪报告，不写文件
#   bash gtd_init.sh --install-cron  # 显式请求安装 GTD 自动节律；纯 shell 只输出 agent handoff，创建由 gtd-init skill 调用平台 automation 工具完成
#
# 设计：David Allen GTD —— 可信系统必须完整（核心八清单物理分开）且零数据破坏（重跑安全）。
# 兼容 macOS bash 3.2（不使用关联数组 / mapfile）。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/gtd_env.sh"
SKILL_DIR="$GTD_SKILL_DIR"
VAULT_ROOT="$GTD_WORKSPACE_ROOT"
GTD_DIR="$VAULT_ROOT/memory/gtd"
LEGACY_FILE="$VAULT_ROOT/memory/open loops.md"
AUTOMATIONS_DIR="${CODEX_HOME:-$HOME/.codex}/automations"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
CODEX_PROMPTS_DIR="$CODEX_HOME_DIR/prompts"
CODEX_PROMPT_TEMPLATES="$SKILL_DIR/templates/codex-prompts"
CODEX_PROMPT_FILES="gtd.md gtd-init.md gtd-capture.md gtd-clarify.md gtd-update.md gtd-organize.md gtd-engage.md gtd-review.md"

IMPORT_LEGACY=0
STATUS_ONLY=0
INSTALL_CRON=0
for arg in "$@"; do
  case "$arg" in
    --import-legacy) IMPORT_LEGACY=1 ;;
    --status)        STATUS_ONLY=1 ;;
    --install-cron)  INSTALL_CRON=1 ;;
    *) echo "未知参数：$arg" >&2; exit 2 ;;
  esac
done

created=0
skipped=0

# 仅当文件不存在时写入（幂等、零破坏）
seed() {
  local path="$1"; shift
  if [ -f "$path" ]; then
    skipped=$((skipped+1))
    return 0
  fi
  cat > "$path"
  created=$((created+1))
  echo "  ✅ 新建 ${path#$VAULT_ROOT/}"
}

# ── 自检：适配层完整性 ──
selfcheck() {
  echo ""
  echo "── 适配层自检 ──"
  local skill_real="$VAULT_ROOT/.cursor/skills/gtd-harness/SKILL.md"
  if [ -f "$skill_real" ]; then
    echo "  ✅ 真源可达：.cursor/skills/gtd-harness/SKILL.md"
  elif [ -f "$SKILL_DIR/SKILL.md" ]; then
    echo "  ✅ 插件真源可达：$SKILL_DIR/SKILL.md"
  else
    echo "  ⚠️  真源缺失：找不到 gtd-harness/SKILL.md"
  fi

  if [ "$GTD_LEGACY_VAULT_INSTALL" -eq 1 ]; then
    local entry
    for entry in .claude/skills .agent/skills .agents/skills; do
      if [ -e "$VAULT_ROOT/$entry/gtd-harness/SKILL.md" ]; then
        echo "  ✅ 入口可达：$entry/gtd-harness（→ .cursor/skills）"
      else
        echo "  ℹ️  入口未解析：$entry/gtd-harness（旧适配入口，可选）"
      fi
    done
    local chk="$VAULT_ROOT/.codex/scripts/check-agent-dirs.sh"
    if [ -f "$chk" ]; then
      echo "  ℹ️  深度校验可跑：bash .codex/scripts/check-agent-dirs.sh"
    fi

    local missing_codex=0
    local prompt
    for prompt in $CODEX_PROMPT_FILES; do
      if [ ! -f "$CODEX_PROMPTS_DIR/$prompt" ]; then
        missing_codex=$((missing_codex+1))
      fi
    done
    if [ "$missing_codex" -eq 0 ]; then
      echo "  ✅ Codex slash 命令可达：$CODEX_PROMPTS_DIR/gtd*.md"
    else
      echo "  ⚠️  Codex slash 命令缺失 $missing_codex 个：$CODEX_PROMPTS_DIR/gtd*.md（旧安装模式下 init 会自动安装/刷新）"
    fi
  else
    echo "  ℹ️  插件模式：以当前工作区作为 GTD 状态根；不需要旧符号链接入口。"
  fi

  if [ -d "$CODEX_PROMPT_TEMPLATES" ]; then
    echo "  ✅ Codex prompt 模板可达：$CODEX_PROMPT_TEMPLATES"
  else
    echo "  ℹ️  Codex prompt 模板缺失（插件模式不需要）：$CODEX_PROMPT_TEMPLATES"
  fi
}

# ── 安装/刷新 Codex slash 命令（全局 CODEX_HOME 级）──
install_codex_prompts() {
  if [ ! -d "$CODEX_PROMPT_TEMPLATES" ]; then
    echo "  ⚠️  未找到 Codex prompt 模板，跳过：${CODEX_PROMPT_TEMPLATES#$VAULT_ROOT/}"
    return 0
  fi
  mkdir -p "$CODEX_PROMPTS_DIR"

  local installed=0
  local updated=0
  local unchanged=0
  local prompt src dst
  for prompt in $CODEX_PROMPT_FILES; do
    src="$CODEX_PROMPT_TEMPLATES/$prompt"
    dst="$CODEX_PROMPTS_DIR/$prompt"
    if [ ! -f "$src" ]; then
      echo "  ⚠️  模板缺失：$prompt"
      continue
    fi
    if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
      unchanged=$((unchanged+1))
    elif [ -f "$dst" ]; then
      cp "$src" "$dst"
      updated=$((updated+1))
    else
      cp "$src" "$dst"
      installed=$((installed+1))
    fi
  done
  echo "  ✅ Codex slash 命令 → ${CODEX_PROMPTS_DIR}/（新装 ${installed}，更新 ${updated}，未变 ${unchanged}）"
}

# ── 自检：自动节律现状（只读，不创建 cron / automation）──
automation_status() {
  local id="$1"
  local label="$2"
  local file="$AUTOMATIONS_DIR/$id/automation.toml"
  if [ -f "$file" ]; then
    local status name
    status="$(awk -F'"' '/^status = / {print $2; exit}' "$file" 2>/dev/null || true)"
    name="$(awk -F'"' '/^name = / {print $2; exit}' "$file" 2>/dev/null || true)"
    [ -n "$status" ] || status="UNKNOWN"
    [ -n "$name" ] || name="$id"
    echo "  ✅ ${label}：已安装（${name}，${status}）"
  else
    echo "  ⚪ ${label}：未安装（需显式安装；见 references/automation-profiles.md）"
  fi
}

automation_selfcheck() {
  echo ""
  echo "── 自动节律自检（只读，不创建）──"
  if [ ! -d "$AUTOMATIONS_DIR" ]; then
    echo "  ⚪ 未找到 Codex automations 目录：$AUTOMATIONS_DIR"
    echo "  ℹ️  若要安装节律，先读 references/automation-profiles.md，再用平台原生 automation 工具显式创建。"
    return 0
  fi

  automation_status "gtd-ai" "每周 Review"
  automation_status "gtd-2" "月度 Reflect"

  local daily_found=0
  if [ -f "$AUTOMATIONS_DIR/gtd/automation.toml" ]; then
    automation_status "gtd" "每日 Engage（上午）"
    daily_found=1
  fi
  if [ -f "$AUTOMATIONS_DIR/gtd-engage/automation.toml" ]; then
    automation_status "gtd-engage" "每日 Engage（晚间）"
    daily_found=1
  fi
  if [ "$daily_found" -eq 0 ]; then
    echo "  ⚪ 每日 Engage：未安装（可选；Approval Radar 可随 Daily Engage 一起启用）"
  fi

  echo "  ℹ️  init 只检查，不静默创建；安装/修改 cron 必须由用户显式同意。"
}

cron_install_handoff() {
  echo ""
  echo "── 自动节律安装请求（agent handoff）──"
  echo "  已检测到 --install-cron。"
  echo "  纯 shell 不能调用 Codex app 的 automation 工具，也不应手写 ~/.codex/automations。"
  echo "  在 Codex / gtd-init skill 场景中，请按 references/automation-profiles.md 调用 automation_update："
  echo "  1. 安装/更新 Weekly Review"
  echo "  2. 安装/更新 Monthly Reflect"
  echo "  3. 安装/更新 Daily Engage + Approval Radar（若启用 approval provider）"
  echo "  完成后重跑：bash scripts/gtd_init.sh --status（旧安装可用 .cursor/skills/gtd-harness/scripts/gtd_init.sh）"
}

# ── 可选：从旧 open loops.md 导入（旧文件只读，不改）──
import_legacy() {
  if [ ! -f "$LEGACY_FILE" ]; then
    echo "  ⚠️  未找到旧文件，跳过导入：${LEGACY_FILE#$VAULT_ROOT/}"
    return 0
  fi
  local na="$GTD_DIR/next-actions.md"
  local wf="$GTD_DIR/waiting-for.md"
  local pj="$GTD_DIR/projects.md"
  local marker="<!-- imported-from-legacy-open-loops -->"
  if grep -qF "$marker" "$na" 2>/dev/null; then
    echo "  ⏭️  已导入过（检测到 marker），跳过以保持幂等"
    return 0
  fi
  echo "  📥 从旧 open loops.md 导入（旧文件保持只读不变）…"
  # awk：抽取某 section header 之后、下一个 "## " 之前的 "- [ ] " 行
  extract() {
    awk -v sec="$1" '
      $0 ~ ("^## " sec) {grab=1; next}
      /^## / && grab {grab=0}
      grab && /^- \[ \] / {print}
    ' "$LEGACY_FILE"
  }
  {
    echo ""
    echo "## 待补轻字段（legacy import $(cat "$VAULT_ROOT/.gtd_import_stamp" 2>/dev/null || echo "imported"))"
    echo "$marker"
    echo "> 从旧 @自己 导入；逐条用 /gtd-clarify 补预计时长 / 精力档 / 真实约束。旧 @ 分组只作兼容，不强制迁移。"
    extract "@自己"
  } >> "$na"
  { echo ""; echo "<!-- imported-from-legacy-open-loops -->"; extract "@等待"; } >> "$wf"
  { echo ""; echo "<!-- imported-from-legacy-open-loops -->"; extract "@项目"; } >> "$pj"
  local n_na n_wf n_pj
  n_na=$(extract "@自己" | wc -l | tr -d ' ')
  n_wf=$(extract "@等待" | wc -l | tr -d ' ')
  n_pj=$(extract "@项目" | wc -l | tr -d ' ')
  echo "  ✅ 导入完成：@自己 $n_na → next-actions / @等待 $n_wf → waiting-for / @项目 $n_pj → projects"
}

# ════════════════════════════════════════════════════════
echo "GTD Skill · init"
echo "Vault：$VAULT_ROOT"

if [ "$STATUS_ONLY" -eq 1 ]; then
  selfcheck
  automation_selfcheck
  if [ "$INSTALL_CRON" -eq 1 ]; then
    cron_install_handoff
  fi
  echo ""
  echo "（--status 模式，未写任何文件）"
  exit 0
fi

mkdir -p "$GTD_DIR"
echo ""
echo "── 搭建 memory/gtd/ 核心八清单 + 产品想法扩展清单（已存在的跳过）──"

seed "$GTD_DIR/inbox.md" <<'EOF'
# 📥 Inbox（收件箱）

> GTD 第一步 Capture 的唯一落点。**零评判**，先丢进来，理清留给 /gtd-clarify。
> 凡占用心智的（行动、想法、待办、提醒、未决）都先进这里——大脑只负责产生想法，不负责储存。

## 待理清

EOF

seed "$GTD_DIR/next-actions.md" <<'EOF'
# ✅ Next Actions（下一步行动）

> 已理清、可立即执行的单步动作行动池。Engage 按情境 / 时间 / 精力 / 优先级临场筛 3-5 条菜单，不要求你面对全清单。
> 动词必须具体（确认/发送/打电话/写），不写「跟进/处理/研究」等空动词。
> 格式：`- [ ] 具体动作 · 预计时长：10分钟 · 精力档：低精力 · 真实约束：需要电脑/采购/准备链/某人在场 · 项目：[[projects#项目名|项目名]]（如属于项目）· 来源：[[笔记]] · 日期：YYYYMMDD`
> 兼容旧 `@电脑/@电话/@外出/@家/@议程` 分组；它们是工具/场景约束，不再是主结构。

## @电脑
> 旧兼容分组：需要电脑/联网是工具约束，不代表 Engage 默认优先推荐。

## @电话
> 旧兼容分组：电话/语音是渠道约束。

## @外出
> 旧兼容分组：外出顺路 / 采购 / 线下办理等硬场景。

## @家
> 旧兼容分组：在家有材料/设备/环境才能做的。

## @议程-[人名]
> 旧兼容分组：下次见到/聊到某人时要提的（按人开子分组，如 `### @议程-老师A`）。

EOF

seed "$GTD_DIR/projects.md" <<'EOF'
# 🎯 Projects（项目）

> 任何需要 **>1 步**才能完成的成果。GTD 铁律：每个 project 必须挂**至少一个明确的下一步行动**，否则它会卡住。
> 格式：
> ```
> ## [项目名]
> - 期望成果：一句话描述「完成长什么样」
> - 下一步行动：
>   - [[next-actions#^block-id|具体下一步行动]]（约束/镜头）
>   - [[waiting-for#^block-id|等待某人交付什么]]（等待，可选）
> - 支持材料：[[reference#条目名|条目名]] / [[项目文档]]
> - 来源：[[笔记]] · 日期：YYYYMMDD
> ```
> 下一步行动至少 1 条，否则是 stalled；可以多条，但只放当前可并行推进的物理动作，不放完整任务树。
>
> 闭环规则：期望成果达成后，删除整个项目块；不要保留「下一步行动：无」。

EOF

seed "$GTD_DIR/waiting-for.md" <<'EOF'
# ⏳ Waiting For（等待）

> 已委派出去、或正在等别人回应的——不是你的下一步，但需追踪，别让它在你这边消失。
> 1:1 / 项目会前扫这里，一条不漏。
> 格式：`- [ ] [人名] · 在等什么 · 约定：[内容或截止] · 来源：[[笔记]] · 委派日期：YYYYMMDD`

## 等待中

EOF

seed "$GTD_DIR/someday-maybe.md" <<'EOF'
# 💭 Someday / Maybe（将来/也许）

> 暂不承诺、但不愿遗忘的——想做的项目、可能的方向、有趣的念头。
> **不是** active 清单：这里的东西现在不行动。每月回顾时扫一遍，把成熟的拉进 projects/next-actions。
> 格式：`- [ ] 想法/可能的项目 · 触发条件（什么情况下值得启动）· 来源：[[笔记]] · 日期：YYYYMMDD`

## 孵化中

EOF

seed "$GTD_DIR/product-ideas.md" <<'EOF'
# Product Ideas / Product Work Intake（产品想法 / 产品工作入口）

> 明确属于产品、功能、场景、机会域的输入放这里，保留原始机会、假设和证据状态。
> 本文件不是冷藏箱：产品/需求规划是主要工作，每条 idea 默认还要同步到 `projects.md` / `next-actions.md`，进入日常可见系统。
> 只有明确说「先存不处理 / 只捕捉」时，才暂不升级为可见工作项。
> Teresa Torres 口径：先保留 opportunity，不急着变 solution；但 GTD 层必须给出下一步验证动作。
> 格式：每个想法一个小节；用 `- [ ] 机会：...` 作为计数行，并写明 `GTD 可见性`。

## 机会池

EOF

seed "$GTD_DIR/calendar.md" <<'EOF'
# 📅 Calendar（硬性时间地形 · hard landscape）

> **只放**特定日期/特定时间才有意义的事——会议、约定、deadline、特定日才能做的动作。
> Allen 铁律：日历是「圣地」，**不放**普通待办（那些归 next-actions）。一放杂事，日历就失去可信度。
>
> **单一日历**：外部 calendar provider 可达时它是 hard landscape，engage/review 直接读它，日程信息完整时可自动写入（见 `references/capability-map.md`）。**本文件仅在外部 provider 不可达时兜底**——记下「待手动加入日历」的时间事，**绝不抄外部日历副本**。reminder provider 留 v2。
> 兜底格式：`- YYYY-MM-DD [HH:MM] · 事项 · 来源：[[笔记]] · ⚠️待手动加入外部日历`

## 时间专属事项（兜底 · 外部 calendar provider 不可达时）

EOF

seed "$GTD_DIR/reference.md" <<'EOF'
# 📚 Reference（参考资料）

> 无需行动、但将来要查的——以及各项目的支持材料指针。
> 注意：**知识/想法类**笔记走 ZK 管线（fleeting-note → 05_每日记录/），不堆这里；这里只放
> 与行动/项目直接相关的备查信息（清单、规格、联系方式、项目支持材料链接）。
> GTD 内部标题引用用 Obsidian heading link：`[[文件名#标题|标题]]`；裸 `[[标题]]` 只用于真实独立文件。

## 备查

## 项目支持材料

EOF

seed "$GTD_DIR/horizons.md" <<'EOF'
# 🔭 Horizons of Focus（六个高度视野）

> GTD 纵轴：横向五步保证「事情没漏」，纵轴保证「在做对的事」。
> 大多数人困在跑道与 10k 之间救火，从不抬头——于是「高效地做着不该做的事」。
> 每周回顾末尾抬升至 30k+，对照「项目是否仍服务于上层」。

## 50,000 ft · 目的与原则（Purpose / Principles）
> 我为什么存在？我的核心价值观与底线？
-

## 40,000 ft · 愿景（Vision）
> 3–5 年后成功长什么样？
-

## 30,000 ft · 目标（Goals）
> 1–2 年要达成的具体目标？
-

## 20,000 ft · 责任领域（Areas of Focus & Accountability）
> 我持续负责的角色/领域（工作、健康、家庭、财务、学习…），每个都需维持在某个标准。
-

## 10,000 ft · 项目（Projects）
> 当前所有项目（= projects.md 镜像，回顾时核对一致）。
> → 见 [[projects]]

## 跑道 · 行动（Actions）
> 此刻的下一步行动清单。
> → 见 [[next-actions]]

EOF

# horizons 内的 [[projects]]/[[next-actions]] 是同目录文件 wikilink，Obsidian 可解析；
# 指向文件内标题时用 [[文件名#标题|标题]]，避免误建独立文件。

if [ "$IMPORT_LEGACY" -eq 1 ]; then
  echo ""
  echo "── 可选导入（旧 open loops.md 只读）──"
  import_legacy
fi

if [ "$GTD_LEGACY_VAULT_INSTALL" -eq 1 ]; then
  echo ""
  echo "── 安装/刷新 Codex slash 命令（全局）──"
  install_codex_prompts
else
  echo ""
  echo "── 插件模式 ──"
  echo "  跳过旧全局 slash prompt 安装；请从插件入口调用 LLM-GTD。"
fi

selfcheck
automation_selfcheck
if [ "$INSTALL_CRON" -eq 1 ]; then
  cron_install_handoff
fi

echo ""
echo "── 就绪报告 ──"
echo "  新建 $created 个文件，跳过（已存在）$skipped 个。"
echo "  可信系统位置：memory/gtd/"
if [ "$IMPORT_LEGACY" -eq 0 ]; then
  echo "  （未导入旧数据。如需一次性导入：bash gtd_init.sh --import-legacy）"
fi
echo ""
echo "  下一步：跑一次捕捉 —— 调用 gtd-harness 的 capture 流程（旧安装可用 /gtd-capture）"
echo "  看全景仪表盘：运行 scripts/gtd_status.sh（旧安装可用 bash .cursor/skills/gtd-harness/scripts/gtd_status.sh）"
echo "  自动节律：见 references/automation-profiles.md；通过 gtd init --install-cron 由 agent 调用 automation 工具安装"
