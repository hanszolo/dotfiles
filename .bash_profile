#!/bin/bash
function git_branch_ps1() {
	git rev-parse 2>/dev/null && echo -e " \033[38;5;11m[\033[38;5;226m$(git rev-parse --abbrev-ref HEAD)\033[38;5;11m]"
}
export PS1="\033[38;5;15m\033[38;5;40m\u \033[38;5;15m\033[38;5;11m[\033[38;5;15m\033[38;5;14m\t\033[38;5;15m\033[38;5;11m]\033[38;5;15m\033[38;5;15m\$(git_branch_ps1) \033[38;5;15m\033[38;5;3m\w\033[38;5;15m\033[38;5;15m\n\[$(tput bold)\]\[$(tput sgr0)\]\033[38;5;15m\033[38;5;10m\\$\[$(tput sgr0)\] "
export PS2="\[\033[38;5;2m\]$\[$(tput sgr0)\]"
export CLICOLOR=1
export LSCOLORS="fxgxcxdxbxegedabagacad"
export EDITOR='subl -w'
export GEM_HOME="$HOME/.gem"
export PATH="~/bin:$PATH:$GEM_HOME:/opt/homebrew/bin/:/usr/local/opt/libpq/bin:"
export EDITOR=/usr/bin/vim
export BASH_SILENCE_DEPRECATION_WARNING=1
export LESS='-R'

alias vi="vim"
alias bashrl="source ~/.bash_profile"
alias bashw="vim ~/.bash_profile && bashrl"
alias gitw="vim ~/.gitconfig"
alias sshw="vim ~/.ssh/config"
alias fig="docker-compose"
alias weather="open https://cdn.shakeshack.com/camera.jpg"

source ~/.bash_variables

# Bash Completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

function getproj() {
 cd "$PROJECTHOME"
 git clone $1
}

function undot() {
  if [[ $# -lt 2 ]]; then
    echo "Ports a dot file into a .svg file.";
    echo "Usage:";
    echo "undot source.dot target.svg";
    return 1
  fi
  if [[ ! -e $1 ]]; then
    echo "file does not exist: $1"
    return 1
  fi
  if [[ $2 =~ ^.*\.svg$ ]]; then
    local svgfile=$2
  else
    local svgfile="$2.svg"
  fi
  dot -Tsvg "$1" > "$svgfile"
}

function web() {
 python3 -m http.server 8086 & ngrok http 8086
 kill_port 8086
}

function fp() {
  if [ -z "$1" ]; then
    echo "Finds all the processes listening to a port. Usage: fp <port number>"; return 80;
  fi
  lsof -i ":$1" | awk '{print $2}' | grep '^[0-9]*$'
}

function kill_port() {
  local pid
  for pid in `fp $1`; do
    kill $pid
  done;
}

function title() {
 echo -ne "\033]0;$@\007"
}

function projdir() {
 if [[ $PWD == $PROJECTHOME/* ]]; then
  local targetDir="$PROJECTHOME"
  local i="$PWD"
  while [[ ! $(dirname "$i") == $targetDir ]]; do
   local i=$(dirname "$i")
 done
 local projname=$(basename "$i")
 echo "$projname"
fi
}

function openproj() {
 if [[ "$#" -ne 1 ]] || [ ! -d "$PROJECTHOME/$1" ] ; then
  return 0;
fi
cd "$PROJECTHOME/$1"
title "$1"

if [[ -n "$VIRTUAL_ENV" ]]; then
  deactivate
fi
if [[ -d ./venv ]]; then
  . ./venv/bin/activate
fi
}

function proj() {
 if [ "$#" -gt 0 ]; then
  if [[ "$@" == list ]] || [[ "$@" == ls ]]; then
   ls $PROJECTHOME | sort | awk 'BEGIN {n=1} {print "-" n++ "- " $1}';
   return 0;
 elif [[ "$@" =~ -([0-9]+)- ]]; then
  local n="${BASH_REMATCH[1]}";
  local name=`ls $PROJECTHOME | sort | head -n $n | tail -n 1`;
  echo "-$n- $name";
  openproj "$name"
  return 0;
elif [[ "$#" == 1 ]]; then
 openproj "$1"
 return 0;
fi
fi
if [[ $PWD == $PROJECTHOME/* ]]; then
  local name=`projdir`
  openproj "$name"
  return 0
fi
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
