#!/bin/bash

# Claude Code Status Line - Powerline Style (Solarized)
# Reads JSON session data from stdin and formats a two-line status display

SEP=$'\xEE\x82\xB0'
RESET="\033[0m"

# Nerd Font icons
ICON_MODEL=$'\uEE0D'   # nf-fa-robot
ICON_DIR=$'\uEA83'     # nf-cod-folder
ICON_GIT=$'\uE725'     # nf-dev-git_branch
ICON_USAGE=$'\uF254'   # nf-fa-hourglass
ICON_CTX=$'\uEEB2'     # nf-fa-gauge

# Read JSON from stdin and cd to the reported cwd so git commands work
JSON=$(cat)
_CWD=$(echo "$JSON" | jq -r '.cwd // empty' 2>/dev/null)
[[ -n "$_CWD" ]] && cd "$_CWD" 2>/dev/null

# Solarized RGB values (R;G;B for truecolor)
BASE02="7;54;66"
BASE0="131;148;150"
CYAN="42;161;152"
BLUE="38;139;210"
GREEN="133;153;0"
YELLOW="181;137;0"
RED="220;50;47"

# Truecolor bg helper — empty string resets to terminal default
color_bg() {
    [[ -n "$1" ]] && echo -ne "\033[48;2;${1}m" || echo -ne "\033[49m"
}

# Powerline segment: text, bg_color, next_bg_color
# fg is always terminal color 0 (black)
segment() {
    local text="$1" bg="$2" next_bg="${3:-}"
    echo -ne "\033[30m"
    color_bg "$bg"
    echo -ne " $text "
    echo -ne "\033[38;2;${bg}m"
    color_bg "$next_bg"
    echo -ne "$SEP"
}

# Extract a top-level JSON string field
json_get() {
    echo "$JSON" | grep -o "\"$1\":[^,}]*" | sed 's/.*://;s/\"//g;s/[[:space:]]//g'
}

# Get git info — returns empty if not in a repo
# Format: branch[*][+] [⇣N][⇡N]
#   *  staged or unstaged changes
#   +  untracked files
#   ⇣N commits behind upstream
#   ⇡N commits ahead of upstream
get_git_info() {
    git rev-parse --git-dir > /dev/null 2>&1 || return

    local branch
    branch=$(git branch --show-current 2>/dev/null)
    [[ -z "$branch" ]] && branch="detached:$(git rev-parse --short HEAD 2>/dev/null)"

    # Dirty markers
    local dirty=""
    local has_staged has_unstaged has_untracked
    has_staged=$(git diff --cached --name-only 2>/dev/null | head -1)
    has_unstaged=$(git diff --name-only 2>/dev/null | head -1)
    has_untracked=$(git ls-files --others --exclude-standard 2>/dev/null | head -1)
    [[ -n "$has_staged" || -n "$has_unstaged" ]] && dirty+="*"
    [[ -n "$has_untracked" ]]                     && dirty+="+"

    # Upstream ahead/behind
    local upstream=""
    local ahead behind
    behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    [[ -n "$behind" && $behind -gt 0 ]] && upstream+="⇣${behind}"
    [[ -n "$ahead"  && $ahead  -gt 0 ]] && upstream+="⇡${ahead}"

    local info="${branch}${dirty}"
    [[ -n "$upstream" ]] && info+=" ${upstream}"
    echo "$info"
}

# Context % → Solarized color
usage_color() {
    if   [[ $1 -ge 90 ]]; then echo "$RED"
    elif [[ $1 -ge 70 ]]; then echo "$YELLOW"
    else                        echo "$GREEN"
    fi
}

# Shorten working directory
get_pwd() {
    local cwd=$(json_get "cwd" | tr -d '"')
    [[ -z "$cwd" ]] && cwd="${PWD}"
    cwd="${cwd/#$HOME/\~}"
    if [[ $(echo "$cwd" | grep -o "/" | wc -l) -gt 2 ]]; then
        echo "...$(echo "$cwd" | rev | cut -d'/' -f1-2 | rev)"
    else
        echo "$cwd"
    fi
}

# Format a resets_at ISO timestamp as countdown (e.g. 3h30m, 5d, 45m)
time_until() {
    local resets_at="$1"
    [[ -z "$resets_at" ]] || [[ "$resets_at" == "null" ]] && return
    local now=$(date +%s)
    local target=$(date -d "$resets_at" +%s 2>/dev/null) || return
    local diff=$(( target - now ))
    [[ $diff -le 0 ]] && echo "now" && return
    local d=$(( diff / 86400 ))
    local h=$(( (diff % 86400) / 3600 ))
    local m=$(( (diff % 3600) / 60 ))
    if   [[ $d -gt 0 ]]; then printf "%dd" "$d"
    elif [[ $h -gt 0 ]]; then printf "%dh%dm" "$h" "$m"
    else printf "%dm" "$m"
    fi
}

# Build usage text: "3h30m:78% 5d:40%"
format_usage() {
    local usage
    usage=$("$(dirname "$0")/usage.sh" 2>/dev/null) || return

    local fh_pct fh_reset week_pct week_reset
    fh_pct=$(echo "$usage"     | jq -r '.five_hour.utilization // empty')
    fh_reset=$(echo "$usage"   | jq -r '.five_hour.resets_at   // empty')
    week_pct=$(echo "$usage"   | jq -r '.seven_day.utilization // empty')
    week_reset=$(echo "$usage" | jq -r '.seven_day.resets_at   // empty')

    local out=""
    [[ -n "$fh_pct" ]]   && out+="$(time_until "$fh_reset"):${fh_pct%.0}%"
    [[ -n "$week_pct" ]] && out+=" $(time_until "$week_reset"):${week_pct%.0}%"
    echo "$out"
}

# Read the task queue from ~/.claude/tasks/{session_id}/*.json
get_task_queue() {
    local session_id=$(echo "$JSON" | jq -r '.session_id // empty')
    [[ -z "$session_id" ]] && return
    local task_dir="$HOME/.claude/tasks/$session_id"
    [[ ! -d "$task_dir" ]] && return

    for f in "$task_dir"/*.json; do
        [[ -f "$f" ]] || continue
        local status subject active_form
        status=$(jq -r '.status' "$f" 2>/dev/null)
        subject=$(jq -r '.subject' "$f" 2>/dev/null)
        active_form=$(jq -r '.activeForm // empty' "$f" 2>/dev/null)
        [[ "$status" == "completed" || "$status" == "deleted" ]] && continue
        if [[ "$status" == "in_progress" ]]; then
            echo "▶ ${active_form:-$subject}"
        else
            echo "○ $subject"
        fi
    done
}

# LINE 1: Model (base02) → Dir (blue) → Git (cyan, if in repo)
line1() {
    local model_display=$(echo "$JSON" | grep -o '"display_name":"[^"]*"' | sed 's/.*"display_name":"//;s/"//')
    [[ -z "$model_display" ]] && model_display="Sonnet"

    local git_info=$(get_git_info)
    local pwd=$(get_pwd)

    echo -ne "${RESET}"
    if [[ -n "$git_info" ]]; then
        segment "${ICON_MODEL} ${model_display}" "$BASE02" "$BLUE"
        segment "${ICON_DIR} ${pwd}"             "$BLUE"   "$CYAN"
        segment "${ICON_GIT} ${git_info}"        "$CYAN"
    else
        segment "${ICON_MODEL} ${model_display}" "$BASE02" "$BLUE"
        segment "${ICON_DIR} ${pwd}"             "$BLUE"
    fi
    echo -e "${RESET}"
}

# LINE 2: Usage (base02) → Context % (green/yellow/red)
line2() {
    local used_pct=$(echo "$JSON" | grep -o '"used_percentage":[^,}]*' | sed 's/.*://;s/[[:space:]]//g')
    [[ -z "$used_pct" ]] || [[ "$used_pct" == "null" ]] && used_pct=0

    local ctx_color; ctx_color=$(usage_color "$used_pct")
    local usage_text; usage_text=$(format_usage)

    echo -ne "${RESET}"
    if [[ -n "$usage_text" ]]; then
        segment "${ICON_USAGE} ${usage_text}" "$BASE0" "$ctx_color"
        segment "${ICON_CTX} ${used_pct}%"   "$ctx_color"
    else
        segment "${ICON_CTX} ${used_pct}%"   "$ctx_color"
    fi
    echo -e "${RESET}"
}

# LINE 3: Task queue (plain text, no powerline)
line3() {
    local tasks
    tasks=$(get_task_queue)
    [[ -z "$tasks" ]] && return

    while IFS= read -r task; do
        echo "  $task"
    done <<< "$tasks"
}

# Main
echo ""
line1
line2
line3
echo ""
