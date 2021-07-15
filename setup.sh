#!/bin/bash

function set_shell() {
	if [[ $SHELL != /bin/bash ]]; then
		echo "Switching shell to bash"
		chsh -s /bin/bash
	fi
}

set_shell

set -eo pipefail
ln -s $PWD/.bash_profile ~/.bash_profile
mkdir -p ~/.ssh/
ln -s $PWD/.ssh/config ~/.ssh/config
ln -s $PWD/.gitconfig ~/.gitconfig

which -s brew || (echo 'Install homebrew first'; exit 1)
which -s realpath || brew install coreutils
brew list bash-completion >>/dev/null 2>&1 || brew install bash-completion


function set_project_home() {
	read -ep "Which directory is project home? (~/Projects/): " proj_dir
	if [ -z "$proj_dir" ]; then
		proj_dir="~/Projects/"
	fi
	echo "export PROJECTHOME=`realpath ${!proj_dir*}`" >> ~/.bash_variables
}

set_project_home
cd ~
source ~/.bash_profile
