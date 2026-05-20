#!/usr/bin/env bash
set -euo pipefail

##################################################################
# Pretty output (matches setup.sh / generate-ssh-key.sh)
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

confirm() {
    local answer
    prompt answer "$1 ${BOLD}[y/N]${NO_COLOR}"
    [[ "$answer" == "y" || "$answer" == "yes" ]]
}

##################################################################
# Paths
##################################################################

REPO="${REPO:-$HOME/.config}"
SSH_KEY_SCRIPT="$REPO/setup/generate-ssh-key.sh"
DEFAULT_KEY="$HOME/.ssh/id_ed25519"

##################################################################
# 1. Global git config
##################################################################

if ! command -v git &>/dev/null; then
    error "git is not installed"
    exit 1
fi

info "Setting up global git config"

current_name=$(git config --global --get user.name 2>/dev/null || true)
current_email=$(git config --global --get user.email 2>/dev/null || true)

prompt git_name  "Your name"  "${current_name:-}"
prompt git_email "Your email" "${current_email:-}"

if [[ -z "$git_name" || -z "$git_email" ]]; then
    error "Name and email are both required"
    exit 1
fi

git config --global user.name  "$git_name"
git config --global user.email "$git_email"

# Sensible defaults — only set if the user hasn't already configured them
maybe_set() {
    local key="$1" value="$2"
    if [[ -z "$(git config --global --get "$key" 2>/dev/null || true)" ]]; then
        git config --global "$key" "$value"
        info "  $key = $value"
    fi
}

maybe_set init.defaultBranch        main
maybe_set pull.rebase               false
maybe_set push.autoSetupRemote      true
maybe_set push.default              simple
maybe_set fetch.prune               true
maybe_set rerere.enabled            true

if command -v nvim &>/dev/null; then
    maybe_set core.editor nvim
fi

completed "Git config set"

##################################################################
# 2. SSH key — find existing or generate
##################################################################

existing_key=""
for key in "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_ecdsa"; do
    if [[ -f "$key" && -f "$key.pub" ]]; then
        existing_key="$key"
        break
    fi
done

if [[ -n "$existing_key" ]]; then
    completed "SSH key found at $existing_key"
else
    warn "No SSH key found"
    if [[ ! -f "$SSH_KEY_SCRIPT" ]]; then
        error "Expected $SSH_KEY_SCRIPT but it's missing"
        error "Either install it there or set REPO to point to the right location"
        exit 1
    fi
    if [[ ! -x "$SSH_KEY_SCRIPT" ]]; then
        warn "$SSH_KEY_SCRIPT is not executable, fixing..."
        chmod +x "$SSH_KEY_SCRIPT"
    fi
    if confirm "Generate one now using generate-ssh-key.sh?"; then
        "$SSH_KEY_SCRIPT"
        existing_key="$DEFAULT_KEY"
    else
        warn "Skipping key generation. Origin switch to SSH will be skipped too."
    fi
fi

##################################################################
# 3. Prompt user to register the key with GitHub, then test
##################################################################

if [[ -n "$existing_key" && -f "$existing_key.pub" ]]; then
    echo
    info "Public key (also copied to clipboard if generate-ssh-key.sh just ran):"
    printf '\n%s\n\n' "$(cat "$existing_key.pub")"
    info "Add it to GitHub: ${BOLD}https://github.com/settings/ssh/new${NO_COLOR}"
    info "Add it to GitLab: ${BOLD}https://gitlab.com/-/user_settings/ssh_keys${NO_COLOR}"
    echo
    printf "%s " "${MAGENTA}?${NO_COLOR} Press Enter once the key is added (or Ctrl+C to abort)..."
    read -r _ </dev/tty

    if confirm "Test SSH connection to github.com?"; then
        info "Connecting to git@github.com (you may be asked to trust the host)..."
        set +e
        ssh -T -o StrictHostKeyChecking=accept-new git@github.com
        rc=$?
        set -e
        # GitHub exits 1 on success (and prints "Hi USERNAME!" on stderr). 255 = network/auth fail.
        if [[ $rc -eq 1 ]]; then
            completed "SSH auth to GitHub works"
        elif [[ $rc -eq 0 ]]; then
            completed "SSH connection succeeded"
        else
            warn "Got exit code $rc — the key probably isn't registered yet, or you need to unlock it"
        fi
    fi
fi

##################################################################
# 4. Convert .config origin from HTTPS to SSH if applicable
##################################################################

if [[ -d "$REPO/.git" ]]; then
    origin=$(git -C "$REPO" remote get-url origin 2>/dev/null || true)

    if [[ -z "$origin" ]]; then
        warn "$REPO is a git repo but has no 'origin' remote — skipping"
    elif [[ "$origin" =~ ^git@ ]]; then
        completed "$REPO already uses SSH origin ($origin)"
    elif [[ "$origin" =~ ^https:// ]]; then
        # https://host/path[.git] -> git@host:path[.git]
        ssh_origin=$(printf '%s' "$origin" | sed -E 's#^https://([^/]+)/#git@\1:#')
        warn "$REPO uses HTTPS origin: $origin"
        info "Would switch to: $ssh_origin"
        if confirm "Switch origin to SSH?"; then
            git -C "$REPO" remote set-url origin "$ssh_origin"
            completed "Origin updated to $ssh_origin"
            info "Verifying with a fetch..."
            set +e
            git -C "$REPO" fetch --dry-run origin &>/dev/null
            fetch_rc=$?
            set -e
            if [[ $fetch_rc -eq 0 ]]; then
                completed "Fetch over SSH works"
            else
                warn "Fetch failed — check that your key is registered on GitHub"
            fi
        fi
    else
        warn "$REPO origin is unrecognized: $origin"
    fi
else
    warn "$REPO is not a git repo, skipping origin check"
fi

echo
completed "Git setup complete"
