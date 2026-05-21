#!/usr/bin/env bash
#
# padots bootstrap
#
# One-liner install:
#   curl -fsSL https://raw.githubusercontent.com/PanosEconomou/configs/main/bootstrap.sh | bash
#
# Or, accepting args:
#   curl -fsSL .../bootstrap.sh -o /tmp/bootstrap.sh && bash /tmp/bootstrap.sh --yes
#
set -euo pipefail

##################################################################
# Pretty output
##################################################################

BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

info()      { printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"; }
warn()      { printf '%s\n' "${YELLOW}! $*${NO_COLOR}"; }
error()     { printf '%s\n' "${RED}x $*${NO_COLOR}" >&2; }
completed() { printf '%s\n' "${GREEN}✓${NO_COLOR} $*"; }

##################################################################
# Configuration 
##################################################################

REPO_URL="${REPO_URL:-https://github.com/PanosEconomou/configs.git}"
REPO_DIR="${REPO_DIR:-$HOME/.config}"
BACKUP_BASE="${BACKUP_BASE:-$HOME/config.bac}"

##################################################################
# 1. Detect distribution and install git
##################################################################

if [[ ! -f /etc/os-release ]]; then
    error "Cannot detect distribution (/etc/os-release missing)"
    exit 1
fi

# shellcheck source=/dev/null
. /etc/os-release
distro_id="${ID:-unknown}"
info "Distribution: ${BOLD}$distro_id${NO_COLOR}"

if ! command -v git &>/dev/null; then
    info "git not found, installing..."
    case "$distro_id" in
        arch|manjaro|archarm)
            sudo pacman -Sy --needed --noconfirm git
            ;;
        fedora|rhel|fedora-asahi-remix)
            sudo dnf install -y git
            ;;
        *)
            error "Unsupported distribution: $distro_id"
            error "Install git manually and re-run this script."
            exit 1
            ;;
    esac
    completed "git installed"
else
    completed "git is already installed"
fi

##################################################################
# 2. Back up existing .config
##################################################################

backup_dir="$BACKUP_BASE"
if [[ -e "$backup_dir" ]]; then
    backup_dir="$BACKUP_BASE.$(date +%Y%m%d-%H%M%S)"
fi

if [[ -d "$REPO_DIR" ]]; then
    info "Backing up $REPO_DIR → $backup_dir"
    cp -a "$REPO_DIR" "$backup_dir"
    completed "Backup at $backup_dir"
else
    info "$REPO_DIR doesn't exist, creating it"
    mkdir -p "$REPO_DIR"
fi

##################################################################
# 3. Overlay-clone the repo
#
# Strategy: git init in-place, fetch from origin, reset --hard to
# the remote default branch. This OVERWRITES files tracked in the
# repo and LEAVES untracked files alone 
##################################################################

# If a stray .git already exists, drop it (the backup has a copy)
if [[ -d "$REPO_DIR/.git" ]]; then
    warn "Existing .git in $REPO_DIR — removing (preserved in backup)"
    rm -rf "$REPO_DIR/.git"
fi

info "Initialising git repo in $REPO_DIR"
git -C "$REPO_DIR" init -q
git -C "$REPO_DIR" remote add origin "$REPO_URL"

info "Fetching from $REPO_URL"
git -C "$REPO_DIR" fetch -q origin

# Discover the remote's default branch (main vs master vs anything else)
default_branch=$(
    git -C "$REPO_DIR" ls-remote --symref origin HEAD 2>/dev/null \
        | awk '/^ref:/ {sub("refs/heads/", "", $2); print $2; exit}'
)
if [[ -z "$default_branch" ]]; then
    for b in main master; do
        if git -C "$REPO_DIR" show-ref --verify --quiet "refs/remotes/origin/$b"; then
            default_branch="$b"
            break
        fi
    done
fi
if [[ -z "$default_branch" ]]; then
    error "Could not determine default branch of $REPO_URL"
    exit 1
fi
info "Using branch: ${BOLD}$default_branch${NO_COLOR}"

# Point HEAD at the right branch name before resetting, so the local
# branch is created with the same name as the remote default.
git -C "$REPO_DIR" symbolic-ref HEAD "refs/heads/$default_branch"

# Reset working tree to remote — overwrites tracked, preserves untracked
git -C "$REPO_DIR" reset --hard "origin/$default_branch"
git -C "$REPO_DIR" branch --set-upstream-to="origin/$default_branch" \
    "$default_branch" 2>/dev/null || true

completed "Repo overlaid into $REPO_DIR (untracked files preserved)"

##################################################################
# 4. Hand off to setup.sh
##################################################################

SETUP_SCRIPT="$REPO_DIR/setup.sh"
if [[ ! -f "$SETUP_SCRIPT" ]]; then
    error "Expected $SETUP_SCRIPT to exist in the cloned repo, but it doesn't"
    exit 1
fi
 
chmod +x "$SETUP_SCRIPT"
 
info "Handing off to ${BOLD}$SETUP_SCRIPT${NO_COLOR}"
echo
# Redirect /dev/tty to stdin so child processes (pacman, ssh-keygen, etc.)
# have a real terminal to read from. Without this, `curl ... | bash` would
# leave them attached to the now-closed pipe and any interactive prompt
# would silently get EOF.
exec bash "$SETUP_SCRIPT" "$@" </dev/tty
