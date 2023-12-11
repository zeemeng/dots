#!/usr/bin/env sh

recursive_ln() (
	SRC="$(readlink -f "$1")"
	DEST="$2"

	if [ -d "$SRC" ]; then
		NEW_DEST="$DEST/$(basename "$SRC")"
		mkdir -pv "$NEW_DEST"

		ls -1A "$SRC" | while read -r SRC_ITEM
			do recursive_ln "$SRC/$SRC_ITEM" "$NEW_DEST"; done
	else
		ln -sf "$SRC" "$DEST"
	fi
)

