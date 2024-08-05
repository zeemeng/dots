#!/usr/bin/env zsh

# The `emulate` built-in applies shell options to emulate the shell named in the argument, in this case POSIX sh
#emulate sh

# Source common profile drop-ins
[ -d ~/.common_profile.d ] && for conf in ~/.common_profile.d/*; do
	. "$conf"
done

# Source drop-in files
[ -d ~/.zprofile.d ] && for conf in ~/.zprofile.d/*; do
	. "$conf"
done

# Source .zshrc
[ -f ~/.zshrc ] && . ~/.zshrc

