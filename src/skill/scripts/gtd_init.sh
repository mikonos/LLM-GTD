#!/usr/bin/env bash
# gtd_init.sh — 幂等搭建 GTD 可信系统（memory/gtd/ 八清单）+ 自检适配层
#
# 用法：
#   bash gtd_init.sh                 # 幂等建八清单 + 自检（已存在清单不覆盖）
#   bash gtd_init.sh --import-legacy # 额外：一次性从旧 memory/open loops.md 导入（旧文件不改）
#   bash gtd_init.sh --status        # 只做自检与就绪报告，不写文件
#
# 设计：David Allen GTD —— 可信系统必须完整（八清单物理分开）且零数据破坏（重跑安全）。
# 兼容 macOS bash 3.2（不使用关联数组 / mapfile）。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/gtd_env.sh"
SKILL_DIR="$GTD_SKILL_DIR"
VAULT_ROOT="$GTD_WORKSPACE_ROOT"
GTD_DIR="$VAULT_ROOT/memory/gtd"
LEGACY_FILE="$VAULT_ROOT/memory/open loops.md"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
CODEX_PROMPTS_DIR="$CODEX_HOME_DIR/prompts"
CODEX_PROMPT_TEMPLATES="$SKILL_DIR/templates/codex-prompts"
CODEX_PROMPT_FILES="gtd.md gtd-init.md gtd-capture.md gtd-clarify.md gtd-organize.md gtd-engage.md gtd-review.md"

IMPORT_LEGACY=0
STATUS_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --import-legacy) IMPORT_LEGACY=1 ;;
    --status)        STATUS_ONLY=1 ;;
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
    echo "  ℹ️  Codex 插件模式：以当前工作区作为 GTD 状态根；不需要旧 slash prompt 接线。"
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
    echo "## 待重新归情境（legacy import $(cat "$VAULT_ROOT/.gtd_import_stamp" 2>/dev/null || echo "imported"))"
    echo "$marker"
    echo "> 从旧 @自己 导入；逐条用 /gtd-clarify 重新判定情境后移入上方 @电脑/@电话/… 分组。"
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
echo "GTD Harness · init"
echo "Vault：$VAULT_ROOT"

if [ "$STATUS_ONLY" -eq 1 ]; then
  selfcheck
  echo ""
  echo "（--status 模式，未写任何文件）"
  exit 0
fi

mkdir -p "$GTD_DIR"
echo ""
echo "── 搭建 memory/gtd/ 八清单（已存在的跳过）──"

seed "$GTD_DIR/inbox.md" <<'EOF'
# 📥 Inbox（收件箱）

> GTD 第一步 Capture 的唯一落点。**零评判**，先丢进来，理清留给 /gtd-clarify。
> 凡占用心智的（行动、想法、待办、提醒、未决）都先进这里——大脑只负责产生想法，不负责储存。

## 待理清

EOF

seed "$GTD_DIR/next-actions.md" <<'EOF'
# ✅ Next Actions（下一步行动）

> 已理清、可立即执行的单步动作。**按情境分组**——你此刻在什么环境/有什么工具，就看对应分组。
> 动词必须具体（确认/发送/打电话/写），不写「跟进/处理/研究」等空动词。
> 格式：`- [ ] 具体动作 · 项目：[[projects#项目名|项目名]]（如属于项目）· 来源：[[笔记]] · 日期：YYYYMMDD`

## @电脑
> 需要电脑/联网才能做的。

## @电话
> 打电话/语音就能推进的。

## @外出
> 出门在外顺路办的（采购/线下）。

## @家
> 只能在家做的。

## @议程-[人名]
> 下次见到/聊到某人时要提的（按人开子分组，如 `### @议程-Alex`）。

EOF

seed "$GTD_DIR/projects.md" <<'EOF'
# 🎯 Projects（项目）

> 任何需要 **>1 步**才能完成的成果。GTD 铁律：每个 project 必须挂**至少一个明确的下一步行动**，否则它会卡住。
> 格式：
> ```
> ## [项目名]
> - 期望成果：一句话描述「完成长什么样」
> - 下一步行动：→ 见 next-actions（情境）  *(必须有，否则是 stalled)*
> - 支持材料：[[reference#条目名|条目名]] / [[项目文档]]
> - 来源：[[笔记]] · 日期：YYYYMMDD
> ```
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

seed "$GTD_DIR/calendar.md" <<'EOF'
# 📅 Calendar（硬性时间地形 · hard landscape）

> **只放**特定日期/特定时间才有意义的事——会议、约定、deadline、特定日才能做的动作。
> Allen 铁律：日历是「圣地」，**不放**普通待办（那些归 next-actions）。一放杂事，日历就失去可信度。
>
> **单一日历（v1.1）**：真实 **Google Calendar** 可达时它是唯一 hard landscape，engage/review 直接读它，写入需显式确认（见 `references/capability-map.md`）。**本文件仅在 GCal 不可达时兜底**——记下「待手动加入日历」的时间事，**绝不抄 GCal 副本**。Apple Reminders 留 v2。
> 兜底格式：`- YYYY-MM-DD [HH:MM] · 事项 · 来源：[[笔记]] · ⚠️待手动加入 GCal`

## 时间专属事项（兜底 · GCal 不可达时）

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

echo ""
if [ "$GTD_LEGACY_VAULT_INSTALL" -eq 1 ]; then
  echo ""
  echo "── 安装/刷新 Codex slash 命令（全局）──"
  install_codex_prompts
else
  echo ""
  echo "── Codex 插件模式 ──"
  echo "  跳过旧全局 slash prompt 安装；请从 Codex 插件入口调用 LLM-GTD。"
fi

selfcheck

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
