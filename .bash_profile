#!/bin/bash
function git_branch_ps1() {
	git rev-parse 2>/dev/null && echo -e " \033[38;5;11m[\033[38;5;226m$(git rev-parse --abbrev-ref HEAD)\033[38;5;11m]"
}
export PS1="\033[38;5;15m\033[38;5;40m\u \033[38;5;15m\033[38;5;11m[\033[38;5;15m\033[38;5;14m\t\033[38;5;15m\033[38;5;11m]\033[38;5;15m\033[38;5;15m\$(git_branch_ps1) \033[38;5;15m\033[38;5;3m\w\033[38;5;15m\033[38;5;15m\n\[$(tput bold)\]\[$(tput sgr0)\]\033[38;5;15m\033[38;5;10m\\$\[$(tput sgr0)\] "
export PS2="\[\033[38;5;2m\]$\[$(tput sgr0)\]"
export CLICOLOR=1
export LSCOLORS="fxgxcxdxbxegedabagacad"
export EDITOR='subl -w'
export PATH="~/bin:$PATH"
export EDITOR=/usr/bin/vim
export BASH_SILENCE_DEPRECATION_WARNING=1

alias vi="vim"
alias bashrl="source ~/.bash_profile"
alias bashw="vim ~/.bash_profile && bashrl"
alias gitw="vim ~/.gitconfig"
alias sshw="vim ~/.ssh/config"

source ~/.bash_variables

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
    svgfile=$2
  else
    svgfile="$2.svg"
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
  for pid in `fp $1`; do
    kill $pid
  done;
}

function title() {
   echo -ne "\033]0;$@\007"
}

function proj() {
   if [ "$#" -gt 0 ]; then
      if [[ "$@" == list ]] || [[ "$@" == ls ]]; then
         ls $PROJECTHOME | sort | awk 'BEGIN {n=1} {print "-" n++ "- " $1}';
         return 0;
      elif [[ "$@" =~ -([0-9]+)- ]]; then
        n="${BASH_REMATCH[1]}";
        name=`ls $PROJECTHOME | sort | head -n $n | tail -n 1`;
        echo "-$n- $name";
        cd "$PROJECTHOME/$name";
        title "$name";
        return 0;
      elif [ -d "$PROJECTHOME/$1" ]; then
         if [ "$#" -gt 1 ]; then
            if [ -d "$PROJECTHOME/$1/$2" ]; then
               cd "$PROJECTHOME/$1/$2";
               title "$1/$2"
               return 0;
            fi
         else
            cd "$PROJECTHOME/$1";
            title "$1"
            return 0;
         fi
      fi
   fi
   if [[ $PWD == $PROJECTHOME/* ]]; then
      targetDir="$PROJECTHOME"
      fragment=""
      if [[ $PWD == $PROJECTHOME/api/* ]]; then
         targetDir="$PROJECTHOME/api"
         fragment="api/"
      fi
      i="$PWD"
      while [[ ! $(dirname "$i") == $targetDir ]]; do
         i=$(dirname "$i")
      done
      projname=$(basename "$i")
      cd "$targetDir/$projname"
      title "$fragment$projname"
      return 0
   fi
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
