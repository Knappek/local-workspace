# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# some more ls aliases
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
source /usr/local/etc/grc.bashrc

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_secure  ] && . ~/.bash_secure

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
  fi
fi

# show current git branch
# Add git branch if its present to PS1
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
parse_subdir() {
  echo ../${PWD#"${PWD%/*/*/*}/"}
}
color_prompt="yes"
if [ "$color_prompt" = yes ]; then
# with cutted directory
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\u\[\033[01;34m\]@\[\033[01;34m\]local:\[\033[01;34m\]\w\n\[\033[01;32m\] ↪  \[\033[01;31m\]$(parse_git_branch)\[\033[00m\] $ '
#PS1='\[\033[00m\]\$ '
else
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt


# git password cache
git config --global credential.helper cache
git config --global credential.helper "cache --timeout=10000"


bind "set completion-ignore-case on" 

# some often used commands
alias gs="git status"
alias gd="git diff"
alias ghist="git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
gitpull() {
  git pull origin $1
}
alias gpull=gitpull
gitbranch() {
  git branch "$@"
}
alias gb=gitbranch
gitpushorigin() {
  git push origin $1
}
alias gp=gitpushorigin
gitpushoriginall() {
  git checkout develop && git merge master && git push origin develop && git checkout master && git merge develop && git push origin master && git checkout develop && git push --tags
}
alias gpall=gitpushoriginall
gitmerge() {
  git merge $1
}
alias gm=gitmerge
gitcheckout() {
  git checkout "$@"
}
alias gc=gitcheckout
gitcommit() {
  git add . --all
  git commit -m "$1"
}
alias gcomm=gitcommit
gitdeletetagremote() {
  git tag -d $1
  git push origin :refs/tags/$1
}
alias gtagdel=gitdeletetagremote
gitflowfeaturestart() {
  git flow feature start $1
}
alias gfeatstart=gitflowfeaturestart
gitflowfeaturefinish() {
  git flow feature finish $(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2)
}
alias gfeatfinish=gitflowfeaturefinish
gitflowreleasestart() {
  git flow release start $1
}
alias grelstart=gitflowreleasestart
gitflowreleasefinish() {
  git flow release finish $(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2)
}
alias grelfinish=gitflowreleasefinish
gitflowhotfixstart() {
  git flow hotfix start $1
}
alias ghotfixstart=gitflowhotfixstart
gitflowhotfixfinish() {
  git flow hotfix finish $(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2)
}
alias ghotfixfinish=gitflowhotfixfinish
gitflowfeaturepublish() {
  git flow feature publish $(git rev-parse --abbrev-ref HEAD | cut -d'/' -f2)
}
alias gfeatpublish=gitflowfeaturepublish

transfersh() {
  curl --upload-file $1 https://transfer.sh/$1
}
alias transfer=transfersh

# save to clipboard
clip() {
  cat $1  | pbcopy
}

# enable kubectl autocompletion
source <(kubectl completion bash)


# transform private ssh key to correct format
id_rsa() {
  gsed -i 's#-----BEGIN RSA PRIVATE KEY-----#&\n#g' $1 && gsed -i 's#-----END RSA PRIVATE KEY-----#\n-----END RSA PRIVATE KEY-----#g' $1 && gsed -i 's#.\{64\}#&\n#g' $1 && chmod 400 $1
}

# for ssh agent forwarding
[ -f ~/.ssh/id_rsa ] && ssh-add ~/.ssh/id_rsa

export PATH=$PATH:/Users/andreas.knapp/bin

source '/Users/andreas.knapp/lib/azure-cli/az.completion'

source ~/.kafka

export GOPATH=~/go/
export PATH=$PATH:$GOPATH/bin
