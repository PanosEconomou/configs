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


usage() {
  printf "%s\n" \
    "setup.sh [option]" \
    "" \
    "Setup padots. This will install a bunch of stuff and configure your linux installation." \
    "It will install hyprland so make sure you are using no window manager atm."

  printf "\n%s\n" "Options"
  printf "\t%s\n\t\t%s\n\n" \
    "-f, -y, --force, --yes" "Skip the confirmation prompt during installation" \
    "-s, --ssh" "Install the ssh version of the repo if it is not there already" \
	"-h, --help" "Display this help message"
}

find_unavailable() {
	unavailable=()

	for pkg in "$@"; do
		case "$distro_id" in
			arch|manjaro)
				if ! pacman -Si "$pkg" &>/dev/null; then
					unavailable+=("$pkg")
				fi
				;;
			fedora|rhel|fedora-asahi-remix)
				if ! dnf info "$pkg" &>/dev/null; then
					unavailable+=("$pkg")
				fi
				;;
			*)
				error "Unsupported distribution: $distro_id"
				exit 1
				;;

		esac
	done

	if [[ ${#unavailable[@]} -gt 0 ]]; then
		warn "The following packages are unavailable from your package manager. Please install them manually"
        printf '  %s\n' "${unavailable[@]}"	
	fi
}

install() {
	case "$distro_id" in
		arch|manjaro)
			sudo pacman -S "$@"
			;;
		fedora|rhel|fedora-asahi-remix)
			if [ -z "${FORCE-}" ]; then 
				sudo dnf install --skip-unavailable "$@"
			else 
				sudo dnf install -y --skip-unavailable "$@"
			fi
			;;
		*)
			error "Unsupported distribution: $distro_id"
			exit 1
			;;

	esac
}

##################################################################
##################################################################

# Some variables that are needed for the setup
REPO="$HOME/.config"
REPO_URL_SSH="git@github.com:PanosEconomou/configs.git"
REPO_URL_HTTPS="https://github.com/PanosEconomou/configs.git"
if [[ -z "${DOWNLOAD_REPO-}" ]]; then
	DOWNLOAD_REPO="$REPO_URL_HTTPS"
fi

# Anything that needs to be symlinked from the repo into the rigth place
# They are in the form target link
symlinks=(
	"$REPO/vimrc $HOME/.vimrc"
	"$REPO/Pictures $HOME/Pictures"
	"$REPO/bash_aliases $HOME/.bash_aliases"
)

##################################################################
##################################################################

# Parse inline arguments
while [ "$#" -gt 0 ]; do
	case "$1" in
		-f | -y | --force | --yes)
    		FORCE=1
    		shift 1
    		;;
		-s | --ssh)
			echo "$DOWNLOAD_REPO"
			DOWNLOAD_REPO="$REPO_URL_SSH"
			echo "$DOWNLOAD_REPO"
			shift 1
			;;			
		-h)
			usage
			exit
			;;
		*)
			error "Unknown option: $1"
			usage
			exit 1
			;;
	esac
done

##################################################################
##################################################################

printf "${BOLD}${GREEN}Welcome to the padots installation!${NO_COLOR}\n"
printf "Let's walk through this together.\n\n"

# Check the linux distribution
# currently only arch and fedora are supported
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    distro_id=$ID
	completed "Linux Distribution: ${BOLD}$distro_id${NO_COLOR}"
else
    error "Cannot detect Linux distribution."
    exit 1
fi

# Check if the repo is downloaded
if ! command -v git &>/dev/null; then
	info "git not found"
	confirm "Install?"
	install git
else
	completed "git is already installed."
fi

# Check if the repo exists
if [[ -d "$REPO/.git" ]]; then
	url=$(git -C "$REPO" remote get-url origin 2>/dev/null)	
	if [[ "$url" == "$REPO_URL_SSH" ]]; then
		completed "Padots repo is cloned via ssh."
	elif  [[ "$url" == "$REPO_URL_HTTPS" ]]; then
		warn "Padots repo is cloned via HTTPS. This is fine but version control might not work."
	else
		error "A repo exsits but it doesn't match. Please fix it before proceeding."
	fi
else
	warn "Padots repo is not installed."
	confirm "Install $DOWNLOAD_REPO at $REPO?"
	git clone "$DOWNLOAD_REPO" "$REPO"
	completed "Padots repo is cloned."
fi

# Let's first some files
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
completed "~/.bashrc modified successfully."

# Now we need to install the relevant hyprland utilities
confirm "Install some fonts?"
case "$distro_id" in
	arch|manjaro)
		mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$REPO/setup/fonts-arch.txt")
		install "--needed" "${packages[@]}"
		;;
	fedora|rhel|fedora-asahi-remix)
		mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$REPO/setup/fonts-fedora.txt")
		install "${packages[@]}"
		;;
	*)
		error "Unsupported distribution: $distro_id"
		exit 1
		;;
esac
completed "Fonts successfully installed."

# Finally we can install some packages
info "Let me check which packages are available through your package manager"
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$REPO/setup/pkglist.txt")
find_unavailable "${package[@]}"

confirm "Install the basic packages?"
install "${packages[@]}"
completed "Basic packages installed"

# Set up SDDM
info "Let's set up the display manager (sddm)"
info "Installing astronaut theme dependencies"
case "$distro_id" in
	arch|manjaro)
		sudo pacman -S qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg 
		;;
	fedora|rhel|fedora-asahi-remix)
		if [ -z "${FORCE-}" ]; then 
			sudo dnf install qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia 
		else 
			sudo dnf install -y qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia 
		fi
		;;
	*)
		error "Unsupported distribution: $distro_id"
		exit 1
		;;
esac
completed "Installed Astronaut Dependencies"

sudo git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
sudo ln -s "$REPO/sddm_theme.conf" "/usr/share/sddm/themes/sddm-astronaut-theme/Themes/sddm_theme.conf"
completed "Successfully cloned the astronaut repo and copied fonts and config"


systemctl enable sddm

