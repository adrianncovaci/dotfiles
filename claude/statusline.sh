#!/usr/bin/env bash
# Claude Code status line, linked to ~/.claude/statusline.sh by install.sh.
#
# Renders one line:
#   Model/effort | dir@branch (+a -d) | 52k/1m ██░░░░░░░░ (5%) | 5h 7% @19:40 | 7d 28% @Thu Jul 23, 08:00 | extra $1.20/$50.00 | v2.1.214
#
# Every segment except extra-usage is rendered from the JSON Claude Code pipes
# to statusLine commands on stdin, documented at
# https://code.claude.com/docs/en/statusline — no other data source is needed.
# Extra-usage credits are the one datum absent from that JSON, so they are
# fetched from the OAuth usage endpoint, throttled through a 60-second cache
# shared across sessions.
#
# GNU tools assumed (date --date, stat --format), so Linux-only as written.

set -o noglob

# Claude Code doesn't always start this from a login shell, so jq from nix may be missing
PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

input=$(cat)

if [ -z "${input}" ]; then
    printf 'Claude'
    exit 0
fi

# ANSI palette (orange deepened from 255,176,85 so it reads as distinct from yellow).
blue='\033[38;2;0;153;255m'
orange='\033[38;2;245;130;30m'
green='\033[38;2;0;160;0m'
cyan='\033[38;2;46;149;153m'
red='\033[38;2;255;85;85m'
yellow='\033[38;2;230;200;0m'
white='\033[38;2;220;220;220m'
dim='\033[2m'
reset='\033[0m'

# Format token counts (e.g. 52k, 1m).
format_tokens() {
    local num=$1
    if [ "${num}" -ge 1000000 ]; then
        LC_NUMERIC=C awk "BEGIN {v=sprintf(\"%.1f\",${num}/1000000)+0; if(v==int(v)) printf \"%dm\",v; else printf \"%.1fm\",v}"
    elif [ "${num}" -ge 1000 ]; then
        LC_NUMERIC=C awk "BEGIN {printf \"%.0fk\", ${num} / 1000}"
    else
        printf '%d' "${num}"
    fi
}

# Color escape for a usage percentage. Thresholds are deliberately low (75/50/25)
# so the warning colors appear early.
usage_color() {
    local pct=$1
    if [ "${pct}" -ge 75 ]; then echo "${red}"
    elif [ "${pct}" -ge 50 ]; then echo "${orange}"
    elif [ "${pct}" -ge 25 ]; then echo "${yellow}"
    else echo "${green}"
    fi
}

claude_config_dir="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"

# ===== Extract all stdin fields in a single jq pass =====
# Joined with the ASCII unit separator (0x1f), not tabs: tab is IFS whitespace,
# so bash `read` collapses consecutive tabs and absent fields would shift the
# variable mapping. Non-whitespace IFS characters delimit every field.
IFS=$'\x1f' read -r model_name effort_level cwd in_tok cc_tok cr_tok ctx_size \
    fh_pct fh_reset sd_pct sd_reset cli_version <<EOF
$(jq --raw-output '[
    (.model.display_name // "Claude"),
    (.effort.level // ""),
    (.workspace.current_dir // .cwd // ""),
    (.context_window.current_usage.input_tokens // 0),
    (.context_window.current_usage.cache_creation_input_tokens // 0),
    (.context_window.current_usage.cache_read_input_tokens // 0),
    (.context_window.context_window_size // 200000),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.rate_limits.seven_day.resets_at // ""),
    (.version // "")
] | map(tostring) | join("\u001f")' <<< "${input}" 2>/dev/null)
EOF

# Belt-and-braces for malformed stdin (jq failure leaves every field empty).
model_name="${model_name:-Claude}"
in_tok="${in_tok:-0}"
cc_tok="${cc_tok:-0}"
cr_tok="${cr_tok:-0}"
ctx_size="${ctx_size:-200000}"

sep=" ${dim}|${reset} "

# ===== Model/effort =====
out="${blue}${model_name}${reset}"
if [ -n "${effort_level}" ]; then
    out+="${dim}/${reset}"
    case "${effort_level}" in
        low)    out+="${green}${effort_level}${reset}" ;;
        medium) out+="${yellow}med${reset}" ;;
        high)   out+="${orange}${effort_level}${reset}" ;;
        xhigh)  out+="${red}${effort_level}${reset}" ;;
        max)    out+="${red}m${yellow}a${cyan}x${reset}" ;;
        *)      out+="${green}${effort_level}${reset}" ;;
    esac
fi

# ===== Directory @ branch (+added -deleted) =====
if [ -n "${cwd}" ]; then
    display_dir="${cwd##*/}"
    git_branch=$(git -C "${cwd}" rev-parse --abbrev-ref HEAD 2>/dev/null)
    out+="${sep}${cyan}${display_dir}${reset}"
    if [ -n "${git_branch}" ]; then
        out+="${dim}@${reset}${cyan}${git_branch}${reset}"
        git_stat=$(git -C "${cwd}" --no-optional-locks diff --numstat 2>/dev/null | awk '{a+=$1; d+=$2} END {if (a+d>0) printf "+%d -%d", a, d}')
        [ -n "${git_stat}" ] && out+=" ${dim}(${reset}${green}${git_stat%% *}${reset} ${red}${git_stat##* }${reset}${dim})${reset}"
    fi
fi

# ===== Context window: tokens + 10-cell bar + percentage =====
# used_percentage is derived from input-side tokens only (same formula as the
# docs), computed locally so tokens/bar/percentage always agree.
current=$(( in_tok + cc_tok + cr_tok ))
[ "${ctx_size}" -gt 0 ] 2>/dev/null || ctx_size=200000
pct_used=$(( current * 100 / ctx_size ))
[ "${pct_used}" -gt 100 ] && pct_used=100

ctx_filled=$(( pct_used * 10 / 100 ))
ctx_empty=$(( 10 - ctx_filled ))
ctx_fstr=""
ctx_estr=""
[ "${ctx_filled}" -gt 0 ] && printf -v _fill "%${ctx_filled}s" "" && ctx_fstr="${_fill// /█}"
[ "${ctx_empty}" -gt 0 ] && printf -v _pad "%${ctx_empty}s" "" && ctx_estr="${_pad// /░}"
ctx_bcol=$(usage_color "${pct_used}")
out+="${sep}${orange}$(format_tokens "${current}")/$(format_tokens "${ctx_size}")${reset}"
out+=" ${ctx_bcol}${ctx_fstr}${reset}${dim}${ctx_estr}${reset}"
out+=" ${dim}(${reset}${ctx_bcol}${pct_used}%${reset}${dim})${reset}"

# ===== Rate limits: 5h and 7d windows =====
# rate_limits is absent until the first API response (and on non-subscriber
# accounts) — show a dim placeholder then.
if [ -n "${fh_pct}" ]; then
    fh_int=$(LC_NUMERIC=C printf '%.0f' "${fh_pct}")
    out+="${sep}${white}5h${reset} $(usage_color "${fh_int}")${fh_int}%${reset}"
    if [ -n "${fh_reset}" ]; then
        fh_time=$(date --date="@${fh_reset}" +"%H:%M" 2>/dev/null)
        [ -n "${fh_time}" ] && out+=" ${dim}@${fh_time}${reset}"
    fi
else
    out+="${sep}${white}5h${reset} ${dim}-${reset}"
fi

if [ -n "${sd_pct}" ]; then
    sd_int=$(LC_NUMERIC=C printf '%.0f' "${sd_pct}")
    out+="${sep}${white}7d${reset} $(usage_color "${sd_int}")${sd_int}%${reset}"
    if [ -n "${sd_reset}" ]; then
        sd_time=$(date --date="@${sd_reset}" +"%a %b %-d, %H:%M" 2>/dev/null)
        [ -n "${sd_time}" ] && out+=" ${dim}@${sd_time}${reset}"
    fi
else
    out+="${sep}${white}7d${reset} ${dim}-${reset}"
fi

# ===== Extra usage (OAuth usage endpoint — not available on stdin) =====
# Token sources, in order: explicit env var, the Linux credentials file,
# GNOME Keyring.
get_oauth_token() {
    if [ -n "${CLAUDE_CODE_OAUTH_TOKEN}" ]; then
        printf '%s' "${CLAUDE_CODE_OAUTH_TOKEN}"
        return 0
    fi
    local token creds_file="${claude_config_dir}/.credentials.json"
    if [ -f "${creds_file}" ]; then
        token=$(jq --raw-output '.claudeAiOauth.accessToken // empty' "${creds_file}" 2>/dev/null)
        if [ -n "${token}" ]; then
            printf '%s' "${token}"
            return 0
        fi
    fi
    if command -v secret-tool >/dev/null 2>&1; then
        token=$(timeout 2 secret-tool lookup service "Claude Code-credentials" 2>/dev/null |
            jq --raw-output '.claudeAiOauth.accessToken // empty' 2>/dev/null)
        if [ -n "${token}" ]; then
            printf '%s' "${token}"
            return 0
        fi
    fi
}

# 60s-TTL cache shared across sessions of the same config dir. touch acts as a
# stampede lock: it refreshes mtime before the fetch so parallel panes don't
# all hit the API; a failed fetch leaves an empty file, removed below so the
# next render retries instead of rendering nothing for a full TTL.
config_hash=$(printf '%s' "${claude_config_dir}" | sha256sum | cut --characters=1-8)
cache_dir="${XDG_RUNTIME_DIR:-${HOME}/.cache}/claude"
cache_file="${cache_dir}/statusline-usage-cache-${config_hash}.json"
cache_max_age=60
mkdir --parents --mode=0700 "${cache_dir}" 2>/dev/null

usage_data=""
needs_refresh=true
if [ -f "${cache_file}" ]; then
    cache_age=$(( $(date +%s) - $(stat --format=%Y "${cache_file}" 2>/dev/null || echo 0) ))
    [ "${cache_age}" -lt "${cache_max_age}" ] && needs_refresh=false
    usage_data=$(cat "${cache_file}" 2>/dev/null)
fi

if ${needs_refresh}; then
    touch "${cache_file}" 2>/dev/null
    token=$(get_oauth_token)
    if [ -n "${token}" ]; then
        response=$(curl --silent --max-time 3 \
            --header "Accept: application/json" \
            --header "Authorization: Bearer ${token}" \
            --header "anthropic-beta: oauth-2025-04-20" \
            --header "User-Agent: claude-code/${cli_version:-unknown}" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ -n "${response}" ] && jq --exit-status '.five_hour' <<< "${response}" >/dev/null 2>&1; then
            usage_data="${response}"
            printf '%s\n' "${response}" > "${cache_file}"
        fi
    fi
    [ -f "${cache_file}" ] && [ ! -s "${cache_file}" ] && rm --force "${cache_file}"
fi

if [ -n "${usage_data}" ]; then
    extra_enabled=$(jq --raw-output '.extra_usage.is_enabled // false' <<< "${usage_data}" 2>/dev/null)
    if [ "${extra_enabled}" = "true" ]; then
        extra_pct=$(jq --raw-output '.extra_usage.utilization // 0' <<< "${usage_data}" | LC_NUMERIC=C awk '{printf "%.0f", $1}')
        extra_used=$(jq --raw-output '.extra_usage.used_credits // empty' <<< "${usage_data}" | LC_NUMERIC=C awk '{printf "%.2f", $1/100}')
        extra_limit=$(jq --raw-output '.extra_usage.monthly_limit // empty' <<< "${usage_data}" | LC_NUMERIC=C awk '{printf "%.2f", $1/100}')
        if [ -n "${extra_used}" ] && [ -n "${extra_limit}" ]; then
            out+="${sep}${white}extra${reset} $(usage_color "${extra_pct}")\$${extra_used}/\$${extra_limit}${reset}"
        else
            out+="${sep}${white}extra${reset} ${green}enabled${reset}"
        fi
    fi
fi

# ===== Claude Code version (from stdin — no subprocess, no cache) =====
[ -n "${cli_version}" ] && out+="${sep}${orange}v${cli_version}${reset}"

printf '%b' "${out}"
