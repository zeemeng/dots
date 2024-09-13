#!/usr/bin/env bash

# Source common profile
if [ -f ~/.shprofile ]; then
	. ~/.shprofile
fi

# Source bash-specific drop-ins 
[ -d ~/.bash_profile.d ] && for conf in ~/.bash_profile.d/*; do
	. "$conf"
done

# Source some local configuration file if it exists
if [ -f ~/.bash_profile.local ]; then
	. ~/.bash_profile.local
fi

# Source .bashrc
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

