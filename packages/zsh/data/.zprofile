#!/usr/bin/env zsh

# The `emulate` built-in applies shell options to emulate the shell named in the argument, in this case POSIX sh
#emulate sh

# Source common profile
if [ -f ~/.shprofile ]; then
	. ~/.shprofile
fi

# Source drop-in files
[ -d ~/.zprofile.d ] && for conf in ~/.zprofile.d/*; do
	. "$conf"
done

# Source some local configuration file if it exists
if [ -f ~/.zprofile.local ]; then
	. ~/.zprofile.local
fi

# Source .zshrc
if [ -f ~/.zshrc ]; then
	. ~/.zshrc
fi

