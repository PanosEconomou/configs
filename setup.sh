#!/usr/bin/env sh

##################################################################
# Some stuff for the installation script to look pretty
##################################################################

BOLD="$(tput bold 2>/dev/null || printf '')"
GREY="$(tput setaf 0 2>/dev/null || printf '')"
UNDERLINE="$(tput smul 2>/dev/null || printf '')"
RED="$(tput setaf 1 2>/dev/null || printf '')"
GREEN="$(tput setaf 2 2>/dev/null || printf '')"
YELLOW="$(tput setaf 3 2>/dev/null || printf '')"
BLUE="$(tput setaf 4 2>/dev/null || printf '')"
MAGENTA="$(tput setaf 5 2>/dev/null || printf '')"
NO_COLOR="$(tput sgr0 2>/dev/null || printf '')"

info() {
  printf '%s\n' "${BOLD}${GREY}>${NO_COLOR} $*"
}

warn() {
  printf '%s\n' "${YELLOW}! $*${NO_COLOR}"
}

error() {
  printf '%s\n' "${RED}x $*${NO_COLOR}" >&2
}

completed() {
  printf '%s\n' "${GREEN}✓${NO_COLOR} $*"
}

confirm() {
  if [ -z "${FORCE-}" ]; then
    printf "%s " "${MAGENTA}?${NO_COLOR} $* ${BOLD}[y/N]${NO_COLOR}"
    set +e
    read -r yn </dev/tty
    rc=$?
    set -e
    if [ $rc -ne 0 ]; then
      error "Error reading from prompt (please re-run with the '--yes' option)"
      exit 1
    fi
    if [ "$yn" != "y" ] && [ "$yn" != "yes" ]; then
      error 'Aborting (please answer "yes" to continue)'
      exit 1
    fi
  fi
}


##################################################################
##################################################################

# Some variables that are needed for the setup
REPO="$HOME/.config"

# Anything that needs to be symlinked from the repo into the rigth place
# They are in the form target link
symlinks=(
	"$REPO/vimrc $HOME/.vimrc"
	"$REPO/Pictures $HOME/Pictures"
	"$REPO/bash_aliases $HOME/.bash_aliases"
)

##################################################################
##################################################################

printf "${BOLD}${GREEN}Welcome to the padots installation!${NO_COLOR}\n"
printf "Let's walk through this together.\n\n"

# Check if the repo is downloaded
# Install git
if ! command -v git &>/dev/null; then
	info "git not found"
	confirm "Install?"
	curl -sS https://starship.rs/install.sh | sh
else
	completed "git is already installed."
fi

# Check if hte repo exists

# Let's first link some files
info "Let's ${BOLD}link some configs${NO_COLOR} to the right places."
info "This is a list of them:"

for symlink in "${symlinks[@]}"; do
	link=$(echo "$symlink" | awk '{print $2}')
	info "  $link"
done
printf "\n"

confirm "Create Symlinks?"

for symlink in "${symlinks[@]}"; do
	target=$(echo "$symlink" | awk '{print $1}')
	link=$(echo "$symlink" | awk '{print $2}')
	
	if [[ ! -e "$link" ]]; then
		ln -s "$target" "$link"
	else
		warn "Skipped: $link already exists"
	fi
done

completed "Symlinks created"


# Install Starship
if ! command -v starship &>/dev/null; then
	info "Starship not found"
	confirm "Install?"
	curl -sS https://starship.rs/install.sh | sh
else
	completed "Starship is already installed."
fi

# Now append some lines bashrc
cat << EOF >> ~/.bashrc
# Start Staship
eval "$(starship init bash)"

# User specific aliases and functions
source ~/.bash_aliases
EOF

# Now we need to install the relevant hyprland utilities
