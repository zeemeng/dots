################################
### Setting Zsh key bindings ###
################################

# Use vi mode
bindkey -v

# Search commands history with pattern search support (the wildcard `*` will use zsh completion)
bindkey "^R" history-incremental-pattern-search-backward


#############################
### Prompt customizations ###
#############################

# Zsh special hook function that is executed before each prompt.
# For documentation on Zsh hook functions, prompt customization sequences, colour 
# codes, and examples, see refs:
# https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
precmd() {
	local EC="$?"
	local CYAN="%B%F{36}"
	local BLUE="%B%F{33}"
	local RED="%B%F{1}"
	local GREEN="%B%F{2}"
	local YELLOW="%F{227}"
	local RESET="%f%b"

	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
	    xterm-color|*-256color) color_prompt=yes;;
	esac
	
	# # set variable identifying the chroot you work in (used in the prompt below)
	# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	#     debian_chroot=$(cat /etc/debian_chroot)
	# fi

	if [ "$color_prompt" = yes ]; then
	    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;38;5;36m\]\u@\h\[\033[00m\]:\[\033[01;38;5;33m\]\w\[\033[00m\]\$ '
		PS1="$CYAN%n@%m$RESET:$BLUE%~$RESET"
	else
	    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#	    PS1='\u@\h:\w'
		PS1="%n@%m:%~"
	fi
	
#	!!! Yanked from .bashrc, not sure how to setup the feature in zsh !!!
#	# If this is an xterm set the title to user@host:dir
#	case "$TERM" in
#	    xterm*|rxvt*)
#	    # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1";;
#	    PS1="\[\e]0;\u@\h: \w\a\]$PS1";;
#	esac

	if command -v git >/dev/null; then
		GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
		GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null)
		if [ "$GIT_BRANCH" ]; then
			PS1="$PS1 (${YELLOW}${GIT_BRANCH}${RESET})"
		elif [ "$GIT_COMMIT" ]; then
			SHORT_HASH=$(printf '%.4s' "$GIT_COMMIT")
			PS1="$PS1 (${YELLOW}${SHORT_HASH}${RESET})"
		fi
	fi

	if [ "$EC" -eq 0 ]; then
		PS1="${PS1}${GREEN} √${RESET}"
	else
		PS1="${PS1}${RED} !${EC}${RESET}"
	fi

	PS1="$PS1 \$ "
}


#####################
### Miscellaneous ###
#####################

# Set the default editor
EDITOR='vim'


###############################
### Sourcing external files ###
###############################

# Source aliases
[ -f ~/.aliases ] && . ~/.aliases

# Source custom shell functions
[ -f ~/.shfuns ] && . ~/.shfuns

# Source some local configuration file if it exists
if [ -f ~/.zshrc.local ]; then 
	. ~/.zshrc.local
fi

