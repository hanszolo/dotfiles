#!/bin/bash
set -eo pipefail
ln -s $PWD/.bash_profile ~/.bash_profile
mkdir -p ~/.ssh/
ln -s $PWD/.ssh/config ~/.ssh/config
ln -s $PWD/.gitconfig ~/.gitconfig

which -s brew || (echo 'Install homebrew first'; exit 1)
which -s realpath || brew install coreutils

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