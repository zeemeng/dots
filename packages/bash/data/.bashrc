# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

#################################################
### Guard for interactive-only shell settings ###
#################################################

# If not running interactively, return early
case $- in
    *i*) ;;
    *) return;;
esac


#################################
### History save file control ###
#################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100
HISTFILESIZE=200

# append to the history file, don't overwrite it
shopt -s histappend


############################
### Source shell-commons ###
############################

if [ -f ~/.shrc ]; then
	. ~/.shrc
fi


#############################
### Setting shell options ###
#############################

# Set bash prompts to "vi" mode on start
set -o vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


#############################
### Prompt customizations ###
#############################

generate_prompt() {
	local EXIT_CODE="$?"

	# Define color variables only if the terminal supports color display
	case "$TERM" in
	    xterm-color|*-256color) ps1_define_colors bash;;
	esac

	# Baseline prompt
	PS1="$PS1_CYAN\u@\h$PS1_RESET:$PS1_BLUE\w$PS1_RESET"

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	    xterm*|rxvt*)
	    PS1="\[\e]0;\u@\h: \w\a\]$PS1";;
	esac

	# Additional segments
	local PS1_GIT_INFO=$(ps1_git_info)
	local PS1_EXIT_STATUS=$(ps1_exit_status $EXIT_CODE)
	PS1="${PS1}${PS1_GIT_INFO}${PS1_EXIT_STATUS} \$ "
}

PROMPT_COMMAND="generate_prompt"


#####################
### Miscellaneous ###
#####################

# If GNU coreutils' `dircolors` is available, use it to set env var LS_COLORS
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
	eval "$(SHELL=/bin/sh lesspipe)"
fi


###############################
### Sourcing external files ###
###############################

# Source drop-in files
if [ -d ~/.bashrc.d ]; then
	for conf in ~/.bashrc.d/*; do
		. "$conf"
	done
fi

# Source some local configuration file if it exists
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi

