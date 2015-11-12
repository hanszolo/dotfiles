function git_branch_ps1() {
	git rev-parse 2>/dev/null && echo -e " \033[38;5;11m[\033[38;5;226m$(git rev-parse --abbrev-ref HEAD)\033[38;5;11m]"
}
export PS1="\033[38;5;15m\033[38;5;40m\u \033[38;5;15m\033[38;5;11m[\033[38;5;15m\033[38;5;14m\t\033[38;5;15m\033[38;5;11m]\033[38;5;15m\033[38;5;15m\$(git_branch_ps1) \033[38;5;15m\033[38;5;3m\w\033[38;5;15m\033[38;5;15m\n\[$(tput bold)\]\[$(tput sgr0)\]\033[38;5;15m\033[38;5;10m\\$\[$(tput sgr0)\] "
export PS2="\[\033[38;5;2m\]$\[$(tput sgr0)\]"
export CLICOLOR=1
export LSCOLORS="fxgxcxdxbxegedabagacad"
export EDITOR='subl -w'
export PATH="~/bin/:$PATH"
export PROJECTHOME="/Users/hanszhou/Desktop/www/"
export EDITOR=/usr/bin/vim

alias bashrl="source ~/.bash_profile"
alias bashw="vim ~/.bash_profile && bashrl"
alias gitw="vim ~/.gitconfig"
alias sshw="vim ~/.ssh/config"

function web() {
   python -m SimpleHTTPServer 8086 & ngrok 8086
}

alias mount_www="sshfs hans@hans.stylesight.com:/var/www/ ~/Desktop/www -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=www"

function get_proj() {
   cd $PROJECTHOME
   if [[ $# -lt 1 ]] 
   then
       echo "Please specify a project name"
       die 0
   fi
   if [[ $1 = "api" ]]
   then
       if [[ $# -gt 1 ]]
       then
           cd ./api
           git clone ssh://ss@devjetty.stylesight.com/var/git_repo/api/$2.git/
           cd ./$2
       else
           echo "Please specify an api project name"
       fi
   else
       git clone ssh://ss@devjetty.stylesight.com/var/git_repo/$1.git/
       cd ./$1
   fi
}
