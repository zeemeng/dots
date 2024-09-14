#!/usr/bin/env bash

# Source common profile
if [ -f ~/.shprofile ]; then
	. ~/.shprofile
fi

# Source bash-specific drop-ins 
if [ -d ~/.bash_profile.d ]; then
	for conf in ~/.bash_profile.d/*; do
		. "$conf"
	done
fi

# Source some local configuration file if it exists
if [ -f ~/.bash_profile.local ]; then
	. ~/.bash_profile.local
fi

# Source .bashrc
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

