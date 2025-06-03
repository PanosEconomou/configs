#!/bin/bash

# Let's define a prompt function
yn () {
	local prompt=${1:-"Continue?"}
	while true; do
		read -p "Continue? (y/n): " yn
		case $yn in
			[Yy]* ) echo "Proceeding..."; break;;
			[Nn]* ) echo "Aborting."; exit;;
			* ) echo "Please answer yes or no (y/n).";;
		esac
	done
}

echo -e "\e[1;36mWelcome to the padot customization! \e[0mLet's set up some stuff\n"

# Let's first link some files
echo  "The first step is to link some configs to the right places.\nThis will be ~/.vimrc, ~/Pictures, and ~/.bash_aliases"

ln -s ~/.config/vimrc ~/.vimrc
ln -s ~/.config/Pictures ~/Pictures
ln -s ~/.config/bash_aliases ~/.bash_aliases

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Now append some lines bashrc
cat << EOF >> ~/.bashrc
# Start Staship
eval "$(starship init bash)"

# User specific aliases and functions
source ~/.bash_aliases
EOF

