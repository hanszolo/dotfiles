#!/bin/bash
ln -s $PWD/.bash_profile ~/.bash_profile
ln -s $PWD/.ssh/config ~/.ssh/config
ln -s $PWD/.gitconfig ~/.gitconfig
cd ~
source .bash_profile
