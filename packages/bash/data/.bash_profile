#!/usr/bin/env bash

# Source common profile drop-ins
[ -d ~/.common_profile.d ] && for conf in ~/.common_profile.d/*; do
	. "$conf"
done

# Source bash-specific drop-ins 
[ -d ~/.bash_profile.d ] && for conf in ~/.bash_profile.d/*; do
	. "$conf"
done

# Source .bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

