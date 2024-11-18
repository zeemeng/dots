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
### Source shell-commons ###
############################

if [ -f ~/.shrc ]; then
	. ~/.shrc
fi


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
	local EXIT_CODE="$?"

	# Define color variables only if the terminal supports color display
	case "$TERM" in
	    xterm-color|*-256color) ps1_define_colors;;
	esac

	# Baseline prompt
	PS1="$PS1_CYAN%n@%m$PS1_RESET:$PS1_BLUE%~$PS1_RESET"

#	!!! Yanked from .bashrc, not sure how to setup the feature in zsh !!!
#	# If this is an xterm set the title to user@host:dir
#	case "$TERM" in
#	    xterm*|rxvt*)
#	    PS1="\[\e]0;\u@\h: \w\a\]$PS1";;
#	esac

	# Additional segments
	local PS1_GIT_INFO=$(ps1_git_info)
	local PS1_EXIT_STATUS=$(ps1_exit_status $EXIT_CODE)
	PS1="${PS1}${PS1_GIT_INFO}${PS1_EXIT_STATUS} \$ "
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

