#!/usr/bin/env sh
# To be run from root of Git repository

pandoc -s -t man -o ./manpage/build/setdots.1 ./manpage/src/setdots.1.md &&
man ./manpage/build/setdots.1

