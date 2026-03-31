#!/bin/bash

# Claude Code Status Line - Powerline Style (Solarized)
# Reads JSON session data from stdin and formats a two-line status display

SEP=$'\xEE\x82\xB0'
RESET="\033[0m"

# Nerd Font icons (raw UTF-8 bytes for bash 3.2 compat — \uXXXX only works in bash 4.2+)
ICON_MODEL=$'\xEE\xB8\x8D'   # U+EE0D nf-fa-robot
ICON_DIR=$'\xEE\xAA\x83'     # U+EA83 nf-cod-folder
ICON_GIT=$'\xEE\x9C\xA5'     # U+E725 nf-dev-git_branch
ICON_USAGE=$'\xEF\x89\x94'   # U+F254 nf-fa-hourglass
ICON_CTX=$'\xEE\xBA\xB2'     # U+EEB2 nf-fa-gauge

# Read JSON from stdin and cd to the reported cwd so git commands work
JSON=$(cat)
_CWD=$(echo "$JSON" | jq -r '.cwd // empty' 2>/dev/null)
[[ -n "$_CWD" ]] && cd "$_CWD" 2>/dev/null

# ANSI color indices (0–7 normal, 8–15 bright)
# The terminal maps these to the active palette (Ghostty: Selenized Light/Dark).
# Note: Selenized Light inverts the usual slot sense — slot 0 ("black") → bg_2
# (light warm gray) and slot 7 ("white") → fg_0 (dark slate).
BG_1=7    # white slot → selenized fg_0 (dark slate background)
RED=1
GREEN=2
YELLOW=3
BLUE=4
VIOLET=5  # magenta slot → selenized magenta/violet
CYAN=6
# Git segment colors: GREEN = clean, YELLOW = dirty
# Context segment colors: CYAN = normal, RED = ≥ 70%

# ANSI background escape from color index; empty resets to terminal default
color_bg() {
    if [[ -z "$1" ]]; then echo -ne "\033[49m"
    elif (( $1 < 8 )); then echo -ne "\033[$((40 + $1))m"
    else echo -ne "\033[$((100 + $1 - 8))m"
    fi
}

# ANSI foreground escape from color index; empty resets to terminal default
color_fg() {
    if [[ -z "$1" ]]; then echo -ne "\033[39m"
    elif (( $1 < 8 )); then echo -ne "\033[$((30 + $1))m"
    else echo -ne "\033[$((90 + $1 - 8))m"
    fi
}

# Powerline segment: text, bg_index, next_bg_index, [fg_index]
# fg defaults to 0 (black slot → light color in Selenized Light, good on accent bgs)
# Pass 7 (white slot → dark color in Selenized Light) for text on light backgrounds
segment() {
    local text="$1" bg="$2" next_bg="${3:-}" fg="${4:-0}"
    color_fg "$fg"
    color_bg "$bg"
    echo -ne " $text "
    color_fg "$bg"
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

# Context % → ANSI color index (cyan normally, red ≥ 70%)
usage_color() {
    if [[ $1 -ge 70 ]]; then echo "$RED"
    else                      echo "$CYAN"
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

# Format a resets_at Unix timestamp as countdown (e.g. 3h30m, 5d, 45m)
time_until() {
    local resets_at="$1"
    [[ -z "$resets_at" ]] || [[ "$resets_at" == "null" ]] && return
    local now; now=$(date +%s)
    local diff=$(( resets_at - now ))
    [[ $diff -le 0 ]] && echo "now" && return
    local d=$(( diff / 86400 ))
    local h=$(( (diff % 86400) / 3600 ))
    local m=$(( (diff % 3600) / 60 ))
    if   [[ $d -gt 0 ]]; then printf "%dd" "$d"
    elif [[ $h -gt 0 ]]; then printf "%dh%dm" "$h" "$m"
    else printf "%dm" "$m"
    fi
}

# Build usage text from rate_limits in the session JSON: "3h30m:27% 5d:38%"
format_usage() {
    local fh_pct fh_reset week_pct week_reset
    fh_pct=$(echo "$JSON"    | jq -r '.rate_limits.five_hour.used_percentage  // empty')
    fh_reset=$(echo "$JSON"  | jq -r '.rate_limits.five_hour.resets_at        // empty')
    week_pct=$(echo "$JSON"  | jq -r '.rate_limits.seven_day.used_percentage  // empty')
    week_reset=$(echo "$JSON"| jq -r '.rate_limits.seven_day.resets_at        // empty')

    local out=""
    [[ -n "$fh_pct" ]]   && out+="$(time_until "$fh_reset"):$(printf '%.0f' "$fh_pct")%"
    [[ -n "$week_pct" ]] && out+=" $(time_until "$week_reset"):$(printf '%.0f' "$week_pct")%"
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

# LINE 1: Model (bg_1) → Dir (blue) → Git (green=clean, yellow=dirty)
line1() {
    local model_display=$(echo "$JSON" | grep -o '"display_name":"[^"]*"' | sed 's/.*"display_name":"//;s/"//')
    [[ -z "$model_display" ]] && model_display="Sonnet"

    local git_info=$(get_git_info)
    local pwd=$(get_pwd)

    local git_color="$GREEN"
    [[ "$git_info" == *"*"* || "$git_info" == *"+"* ]] && git_color="$YELLOW"

    echo -ne "${RESET}"
    if [[ -n "$git_info" ]]; then
        segment "${ICON_MODEL} ${model_display}" "$BG_1"       "$BLUE"       0
        segment "${ICON_DIR} ${pwd}"             "$BLUE"       "$git_color"
        segment "${ICON_GIT} ${git_info}"        "$git_color"
    else
        segment "${ICON_MODEL} ${model_display}" "$BG_1" "$BLUE" 0
        segment "${ICON_DIR} ${pwd}"             "$BLUE"
    fi
    echo -e "${RESET}"
}

# LINE 2: Usage (base02) → Context % (green/yellow/red)
line2() {
    local used_pct
    used_pct=$(echo "$JSON" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
    [[ -z "$used_pct" || "$used_pct" == "null" ]] && used_pct=0

    local ctx_color; ctx_color=$(usage_color "$used_pct")
    local usage_text; usage_text=$(format_usage)

    echo -ne "${RESET}"
    if [[ -n "$usage_text" ]]; then
        segment "${ICON_USAGE} ${usage_text}" "$VIOLET" "$ctx_color"
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
