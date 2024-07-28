# The `emulate` built-in applies shell options to emulate the shell named in the argument, in this case POSIX sh
#emulate sh

# Use vi mode
bindkey -v

# Search commands history with pattern search support (the wildcard `*` will use zsh completion)
bindkey "^R" history-incremental-pattern-search-backward


# Source aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi


# Some settings added by "nvm"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Custom function to "cd" and "ls" a given directory
c () {
	cd "$@" && printf "> $(pwd)\n\n" && ls -lAhF
}

