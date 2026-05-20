#!/usr/bin/env bash
set -euo pipefail

##################################################################
# Pretty output (matches setup.sh)
##################################################################

BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

info()      { printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"; }
warn()      { printf '%s\n' "${YELLOW}! $*${NO_COLOR}"; }
error()     { printf '%s\n' "${RED}x $*${NO_COLOR}" >&2; }
completed() { printf '%s\n' "${GREEN}✓${NO_COLOR} $*"; }

prompt() {
    local var_name="$1" prompt_text="$2" default="${3-}"
    local input
    if [[ -n "$default" ]]; then
        printf "%s " "${MAGENTA}?${NO_COLOR} $prompt_text ${BOLD}[$default]${NO_COLOR}"
    else
        printf "%s " "${MAGENTA}?${NO_COLOR} $prompt_text"
    fi
    read -r input </dev/tty
    if [[ -z "$input" && -n "$default" ]]; then
        input="$default"
    fi
    printf -v "$var_name" '%s' "$input"
}

##################################################################
# Defaults & argument parsing
##################################################################

KEY_TYPE="ed25519"
KEY_PATH="$HOME/.ssh/id_ed25519"
KEY_COMMENT=""
NO_CLIPBOARD=""

usage() {
    cat <<EOF
gen-ssh-key.sh [options]

Generate an SSH key, add it to ssh-agent (if running), and copy
the public key to the clipboard for pasting into GitHub/GitLab/etc.

Options:
  -t, --type TYPE       Key type (default: ed25519)
  -f, --file PATH       Output path (default: ~/.ssh/id_ed25519)
  -c, --comment STR     Comment to attach to the key (default: user@host)
      --no-clipboard    Don't try to copy, just print the key
  -h, --help            Show this help
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        -t|--type)        KEY_TYPE="$2"; shift 2 ;;
        -f|--file)        KEY_PATH="$2"; shift 2 ;;
        -c|--comment)     KEY_COMMENT="$2"; shift 2 ;;
        --no-clipboard)   NO_CLIPBOARD=1; shift 1 ;;
        -h|--help)        usage; exit 0 ;;
        *)                error "Unknown option: $1"; usage; exit 1 ;;
    esac
done

##################################################################
# Generate key
##################################################################

mkdir -p "$(dirname "$KEY_PATH")"
chmod 700 "$(dirname "$KEY_PATH")"

if [[ -f "$KEY_PATH" ]]; then
    warn "A key already exists at $KEY_PATH"
    prompt overwrite "Overwrite? [y/N]"
    if [[ "$overwrite" == "y" || "$overwrite" == "yes" ]]; then
        rm -f "$KEY_PATH" "$KEY_PATH.pub"
    else
        info "Keeping existing key. Will still add to agent and copy the public key."
    fi
fi

if [[ ! -f "$KEY_PATH" ]]; then
    if [[ -z "$KEY_COMMENT" ]]; then
        default_comment="$USER@$(hostname)"
        prompt KEY_COMMENT "Comment for the key (your email is conventional)" "$default_comment"
    fi

    info "Generating $KEY_TYPE key at $KEY_PATH"
    info "You'll be prompted for an optional passphrase (press Enter twice for none)."
    ssh-keygen -t "$KEY_TYPE" -C "$KEY_COMMENT" -f "$KEY_PATH"
    completed "Key generated"
fi

##################################################################
# Add to ssh-agent (best effort)
##################################################################

if [[ -n "${SSH_AUTH_SOCK-}" ]]; then
    set +e
    ssh-add "$KEY_PATH" 2>/dev/null
    add_rc=$?
    set -e
    if [[ $add_rc -eq 0 ]]; then
        completed "Key added to ssh-agent"
    else
        warn "Could not add key to ssh-agent — ssh will still use it from disk"
    fi
else
    warn "No ssh-agent detected in this session."
    warn "To start one persistently, add to your shell rc:"
    warn "    eval \"\$(ssh-agent -s)\""
    warn "Or enable the user service: systemctl --user enable --now ssh-agent.service"
fi

##################################################################
# Copy public key to clipboard
##################################################################

pub_key="$(cat "$KEY_PATH.pub")"

copy_to_clipboard() {
    local data="$1"
    if [[ -n "${WAYLAND_DISPLAY-}" ]] && command -v wl-copy &>/dev/null; then
        printf '%s' "$data" | wl-copy
        printf 'wl-copy'
        return 0
    fi
    if [[ -n "${DISPLAY-}" ]] && command -v xclip &>/dev/null; then
        printf '%s' "$data" | xclip -selection clipboard
        printf 'xclip'
        return 0
    fi
    if [[ -n "${DISPLAY-}" ]] && command -v xsel &>/dev/null; then
        printf '%s' "$data" | xsel --clipboard --input
        printf 'xsel'
        return 0
    fi
    if command -v pbcopy &>/dev/null; then
        printf '%s' "$data" | pbcopy
        printf 'pbcopy'
        return 0
    fi
    return 1
}

if [[ -z "$NO_CLIPBOARD" ]]; then
    set +e
    tool=$(copy_to_clipboard "$pub_key")
    copy_rc=$?
    set -e
    if [[ $copy_rc -eq 0 ]]; then
        completed "Public key copied to clipboard (via $tool)"
    else
        warn "No clipboard tool available (tried wl-copy, xclip, xsel, pbcopy)."
        warn "On Wayland install wl-clipboard; on X11 install xclip or xsel."
    fi
fi

echo
info "Your public key:"
printf '\n%s\n\n' "$pub_key"
info "Add it to GitHub: https://github.com/settings/ssh/new"
info "Add it to GitLab: https://gitlab.com/-/user_settings/ssh_keys"
info "After adding, test with: ssh -T git@github.com"
