#!/usr/bin/env bash

# Source drop-in files
[ -d ~/.bash_profile.d ] && for conf in ~/.bash_profile.d/*; do
	. "$conf"
done

# Source .bashrc
[ -f ~/.bashrc ] && . ~/.bashrc

