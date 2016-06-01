# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export CVSEDITOR=vim
export CVS_RSH=ssh

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make history really long
HISTFILESIZE=1000000000
HISTSIZE=1000000

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# Bash auto-completion paths
source ~/.git-completion.bash

# To correct the ESC[ characters that come out of git diff
export LESS="-F -X -R"

# For auto-completion to work in man
complete -cf man

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# Changing the default prompt, with some colours
export PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\] '

export OMP_NUM_THREADS=1

# Source local machine dependent settings
source ~/.bashrc_local

# added by Anaconda2 2.4.1 installer
export PATH="/ptmp/packages/anaconda2/bin:$PATH"

# tmux - force tmux to use 256 colours
alias tmux='tmux -2 -L newenv'
