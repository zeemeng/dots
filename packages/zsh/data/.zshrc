#################################################
### Guard for interactive-only shell settings ###
#################################################

# If not running interactively, return early
case $- in
    *i*) ;;
    *) return;;
esac


#############################
### Set Zsh shell options ###
#############################

# set -o POSIX_JOBS # Disabled for the sake of `nvm` (which does not function properly with this option on)
set -o POSIX_ALIASES
set -o POSIX_ARGZERO
set -o POSIX_BUILTINS # Especially since the default behaviour of Zsh's `getopts` differs from POSIX
set -o POSIX_TRAPS
# set -o SH_GLOB # Disabled since Zsh feature might be useful interactively
# set -o SH_FILE_EXPANSION # Disabled since Zsh feature might be useful interactively
# set -o SH_NULLCMD # Disabled since Zsh feature might be useful interactively
set -o SH_OPTION_LETTERS
set -o SH_WORD_SPLIT # Very important assumption. Will be required for proper behaviour of certain custom shell functions


############################
### Set Zsh key bindings ###
############################

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

	if [ "$color_prompt" = yes ]; then
	    # PS1='\[\033[01;38;5;36m\]\u@\h\[\033[00m\]:\[\033[01;38;5;33m\]\w\[\033[00m\]\$ '
		PS1="$CYAN%n@%m$RESET:$BLUE%~$RESET"
	else
	    # PS1='\u@\h:\w\$ '
		PS1="%n@%m:%~"
	fi

#	!!! Yanked from .bashrc, not sure how to setup the feature in zsh !!!
#	# If this is an xterm set the title to user@host:dir
#	case "$TERM" in
#	    xterm*|rxvt*)
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


####################################
### Enable Zsh completion system ###
####################################

# Needs to autoload and call function `compinit` before adding program-specific/third-party
# completion functions (i.e. Before sourcing drop-in files).
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#index-compinit
#
# Ignore insecure directories found by compaudit with -i option when calling compinit
# https://github.com/zsh-users/zsh/blob/master/Completion/compinit#L67
autoload -U compinit
compinit -i


############################
### Source shell-commons ###
############################

if [ -f ~/.shrc ]; then
	. ~/.shrc
fi


###############################
### Source external files ###
###############################

# Source drop-in files
if [ -d ~/.zshrc.d ]; then
	for conf in ~/.zshrc.d/*; do
		. "$conf"
	done
fi

# Source some local configuration file if it exists
if [ -f ~/.zshrc.local ]; then
	. ~/.zshrc.local
fi

