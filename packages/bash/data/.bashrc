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
	local EC="$?"

	# Variables to help produce a properly formatted SGR sequence wrapped as a non-printing
	# Bash prompt sequence. A valid PS1 sequence shall be of a format like such:
	# 	${ESC_L}${SGR_L}...${SGR_R}${ESC_R}
	# where '...' represents a colon separated list of SGR parameters.
	#
	# See references:
	# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
	# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
	#
	# Excerpt:
	# 38	Set foreground color	Next arguments are 5;n or 2;r;g;b
	# 38	Set foreground color	Next arguments are 5;n or 2;r;g;b
	#
	# For values of `n`, see:
	# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

	local ESC_L='\[' # Start of unprintable bash PS1 sequence
	local ESC_R='\]' # End of unprintable bash PS1 sequence
	local SGR_L='\033[' # ANSI Control Sequence Introducer (CSI) token
	local SGR_R='m'
	local BOLD_FG='1;38;' # SGR params.
	local RESET='0' # SGR param. Turn off all attributes

	local CYAN="${ESC_L}${SGR_L}${BOLD_FG}5;36${SGR_R}${ESC_R}"
	local BLUE="${ESC_L}${SGR_L}${BOLD_FG}5;33${SGR_R}${ESC_R}"
	local RED="${ESC_L}${SGR_L}1;31${SGR_R}${ESC_R}"
	local GREEN="${ESC_L}${SGR_L}1;32${SGR_R}${ESC_R}"
	local YELLOW="${ESC_L}${SGR_L}38;5;227${SGR_R}${ESC_R}"
	local RESET="${ESC_L}${SGR_L}0${SGR_R}${ESC_R}"

	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
	    xterm-color|*-256color) color_prompt=yes;;
	esac

	if [ "$color_prompt" = yes ]; then
	    # PS1='\[\033[01;38;5;36m\]\u@\h\[\033[00m\]:\[\033[01;38;5;33m\]\w\[\033[00m\]\$ '
		PS1="$CYAN\u@\h$RESET:$BLUE\w$RESET"
	else
	    # PS1='\u@\h:\w\$ '
	    PS1='\u@\h:\w'
	fi

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	    xterm*|rxvt*)
	    PS1="\[\e]0;\u@\h: \w\a\]$PS1";;
	esac

	if command -v git >/dev/null; then
		GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
		GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null)
		if [ "$GIT_BRANCH" ]; then
			PS1="$PS1 (${YELLOW}${GIT_BRANCH}${RESET})"
		elif [ "$GIT_COMMIT" ]; then
			PS1=$(printf "$PS1 ($YELLOW%.4s$RESET)" "$GIT_COMMIT")
		fi
	fi

	if [ "$EC" -eq 0 ]; then
		PS1="${PS1}${GREEN} √${RESET}"
	else
		PS1="${PS1}${RED} !${EC}${RESET}"
	fi

	PS1="$PS1 \$ "
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

