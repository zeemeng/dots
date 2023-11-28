#!/usr/bin/env sh
# To be run from root of Git repository

pandoc -s -t man -o ./manpage/roff/setdots.1 ./manpage/src/setdots.1.md

