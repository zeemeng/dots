#!/usr/bin/env sh

REQUESTED_PKGS=""
INSTALL_PKGS=""
SETUP_PKGS=""
SKIP_PKGS=""
NEW_LINE="
"

# Technically unnecessary, since 'utils.sh' already sourced in main 'confman' script, but re-sourcing for clarity.
. "$CONFMAN_DIR/lib/utils.sh"

print_usage_exit() {
	cat <<- EOF
	USAGE:
	confman [-iIs] [-m pkg_mgr] [-d config_dest] [-g config_repo] [-p prompt_lvl] [-f pkg_list] [package ...]
	confman [-uUr] [-m pkg_mgr] [-d config_dest] [-g config_repo] [-p prompt_lvl] [-f pkg_list] [package ...]
	confman [-l] [-f pkg_list] [package ...]
	confman [-vhH]

	EOF
	exit 1
}

print_version_exit() {
	printf "confman $(cat "$CONFMAN_DIR/version")\n"
	exit 0
}

show_manpage_exit() {
	man "$CONFMAN_DIR/doc/man/confman.1"
	exit 0
}

warn_about_skipped_packages() {
	if [ -z "$SKIP_PKGS" ]; then return; fi

	"$CONFMAN_LOG" warning "Skipping the following package(s) as they do not support the requested operation(s) on the current platform:"
	printf "$SKIP_PKGS\n\n"
}

# Depends on pre-defined variables: CONFMAN_REPO, PKG, REQUESTED_PKGS, INSTALL_PKGS, SETUP_PKGS, SKIP_PKGS, NEW_LINE
append_to_pkg_lists() {
	# Check if PKG contains any non-whitespace character. If it does, continue, otherwise return
	if ! echo "$PKG" | grep -q "[^[:space:]]"; then return; fi

	# Skip the meta package 'default' which holds the default PKG scripts
	if [ "default" = "$PKG" ]; then return; fi

	# Append to the list of requested pkgs
	REQUESTED_PKGS="${REQUESTED_PKGS}${PKG}${NEW_LINE}"

	# If any line in the "$CONFMAN_REPO/$PKG/platform" file is a case insensitive BRE matching any part
	# of the output of `uname -s`, continue processing, else return.
	if [ -f "$CONFMAN_REPO/$PKG/platform" ] && ! { uname -s | grep -i -q -f "$CONFMAN_REPO/$PKG/platform"; }; then
		SKIP_PKGS="${SKIP_PKGS}${PKG}${NEW_LINE}"
		return
	fi

	if [ -f "$CONFMAN_REPO/$PKG/noinstall" ] && [ -f "$CONFMAN_REPO/$PKG/nosetup" ]; then
		SKIP_PKGS="${SKIP_PKGS}${PKG}${NEW_LINE}"
		return
	fi

	if [ -f "$CONFMAN_REPO/$PKG/noinstall" ]; then
		SETUP_PKGS="${SETUP_PKGS}${PKG}${NEW_LINE}"
		return
	fi

	if [ -f "$CONFMAN_REPO/$PKG/nosetup" ]; then
		INSTALL_PKGS="${INSTALL_PKGS}${PKG}${NEW_LINE}"
		return
	fi

	if [ -d "$CONFMAN_REPO/$PKG" ]; then
		SETUP_PKGS="${SETUP_PKGS}${PKG}${NEW_LINE}"
		INSTALL_PKGS="${INSTALL_PKGS}${PKG}${NEW_LINE}"
		return
	fi
}

read_selected_packages() {
	# Select packages from operands
	for PKG in "$@"; do append_to_pkg_lists; done

	# If specified file exists and can be read, select packages from file line-by-line
	if [ -f "$PKG_FILE" ] && [ -r "$PKG_FILE" ]; then
		while read -r PKG; do append_to_pkg_lists; done < "$PKG_FILE"

	# Specified file exists, but cannot be read
	elif [ "$PKG_FILE" ]; then
		"$CONFMAN_LOG" warning "Cannot read package list file. Defaulting to select all packages from repository."
		prompt_continuation_or_exit
		unset f;
	fi

	# If no operand and no package-list file is specified, select all packages from the target package repository
	if [ "$#" -eq 0 ] && [ ! "$PKG_FILE" ]; then
		while read -r PKG; do
			if [ -d "$CONFMAN_REPO/$PKG" ]; then append_to_pkg_lists; fi
		done <<-EOF
		$(ls -1A "$CONFMAN_REPO")
		EOF
	fi

	# Sort and remove duplicate items in PKG lists
	REQUESTED_PKGS="$(printf "$REQUESTED_PKGS" | sort -u)"
	INSTALL_PKGS="$(printf "$INSTALL_PKGS" | sort -u)"
	SETUP_PKGS="$(printf "$SETUP_PKGS" | sort -u)"
	SKIP_PKGS="$(printf "$SKIP_PKGS" | sort -u)"
}

print_exit_selected_packages() {
	PLATFORM_COLUMN=
	INSTALL_COLUMN=
	UNINSTALL_COLUMN=
	CONFIG_COLUMN=
	RM_CONFIG_COLUMN=

	# Print header
	printf "%-20s%-20s%-20s%-20s%-20s%-20s\n" "Package Name" "Platform" "Install" "Uninstall" "Setup" "Unset"
	printf "=============================================================================================================\n"

	printf '%s\n' "$REQUESTED_PKGS" | while read -r PKG; do
		# "Package Name" column
		printf "%-20s" "$PKG"

		PLATFORM_COLUMN='ALL'
		if [ -f "$CONFMAN_REPO/$PKG/platform" ]; then
			PLATFORM_COLUMN="$(tr '\n' ',' < "$CONFMAN_REPO/$PKG/platform" | sed 's/,$//')"
		fi
		printf "%-20s" "$PLATFORM_COLUMN"

		# "Install" and "Uninstall" columns
		INSTALL_COLUMN=""; UNINSTALL_COLUMN=""; # Reset vars for each iteration
		if [ -f "$CONFMAN_REPO/$PKG/noinstall" ]; then
			INSTALL_COLUMN="NO INSTALL"
		else
			if [ -f "$CONFMAN_REPO/$PKG/install" ]; then INSTALL_COLUMN="CUSTOM"; else INSTALL_COLUMN="DEFAULT"; fi
			if [ -f "$CONFMAN_REPO/$PKG/preinstall" ]; then INSTALL_COLUMN="${INSTALL_COLUMN}, PRE"; fi
			if [ -f "$CONFMAN_REPO/$PKG/postinstall" ]; then INSTALL_COLUMN="${INSTALL_COLUMN}, POST"; fi

			if [ -f "$CONFMAN_REPO/$PKG/uninstall" ]; then UNINSTALL_COLUMN="CUSTOM"; else UNINSTALL_COLUMN="DEFAULT"; fi
		fi
		printf "%-20s%-20s" "$INSTALL_COLUMN" "$UNINSTALL_COLUMN"

		# "Configure" and "RM Config" column
		CONFIG_COLUMN="";RM_CONFIG_COLUMN=""; # Reset vars for each iteration
		if [ -f "$CONFMAN_REPO/$PKG/nosetup" ]; then
			CONFIG_COLUMN="NO SETUP"
		else
			if [ -f "$CONFMAN_REPO/$PKG/setup" ]; then CONFIG_COLUMN="CUSTOM"; else CONFIG_COLUMN="DEFAULT"; fi
			if [ -f "$CONFMAN_REPO/$PKG/presetup" ]; then CONFIG_COLUMN="${CONFIG_COLUMN}, PRE"; fi
			if [ -f "$CONFMAN_REPO/$PKG/postsetup" ]; then CONFIG_COLUMN="${CONFIG_COLUMN}, POST"; fi

			if [ -f "$CONFMAN_REPO/$PKG/unset" ]; then RM_CONFIG_COLUMN="CUSTOM"; else RM_CONFIG_COLUMN="DEFAULT"; fi
		fi
		printf "%-20s%-20s" "$CONFIG_COLUMN" "$RM_CONFIG_COLUMN"
		printf "\n"
	done
	exit 0
}

execute_script() (
	PKG="$1" # Desc: package name
	DEFAULT_OR_CUSTOM="$2" # Values: 'default' | 'custom'
	SCRIPT="$3" # Desc: path to the file to execute
	NEXT_OPERATION="$4" # Desc: Name of the subsequent operation to be performed
	SCRIPT_NAME="$(basename "$SCRIPT")"

	"$CONFMAN_LOG" info "Performing $DEFAULT_OR_CUSTOM $("$CONFMAN_LOG" highlight "$SCRIPT_NAME") for $("$CONFMAN_LOG" highlight "$PKG")"

	if [ ! -x "$SCRIPT" ]; then
		"$CONFMAN_LOG" warning "Adding execute permission to $DEFAULT_OR_CUSTOM \"$SCRIPT_NAME\" file for \"$PKG\""
		if ! chmod ug+x "$SCRIPT" 2>/dev/null; then
			"$CONFMAN_LOG" warning "User '$(whoami)' does not have permission to 'chmod' file '$SCRIPT'. Requesting 'chmod ug+x' on file with 'sudo'.."
			sudo chmod ug+x "$SCRIPT"
		fi
	fi

	# Invoke the specified script as a command to enable execution by a different interpreter or as a standalone executable
	if "$SCRIPT"; then
		"$CONFMAN_LOG" success "SUCCESSFULLY performed $DEFAULT_OR_CUSTOM \"$SCRIPT_NAME\" for \"$PKG\"\n"
	else
		"$CONFMAN_LOG" error "An error occured during $DEFAULT_OR_CUSTOM \"$SCRIPT_NAME\" for \"$PKG\""
		if [ "$NEXT_OPERATION" ]; then "$CONFMAN_LOG" error "Skipping \"$NEXT_OPERATION\" for \"$PKG\""; fi
		printf '\n'
	fi
)

dispatch_operations() {
	OPERATION="$1" # Values: 'install' | 'setup' | 'uninstall' | 'unset'

	# Update/sync back-end package manager repositories. Set options and environment variables
	if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'uninstall' ]; then
		init_pkg_manager;
		TARGET_PKGS="$INSTALL_PKGS"
	else # For OPERATION == 'setup' | 'unset'
		TARGET_PKGS="$SETUP_PKGS"
	fi

	if [ -z "$TARGET_PKGS" ]; then
		"$CONFMAN_LOG" warning "No package available for $OPERATION.. Done."
		return 0
	fi

	"$CONFMAN_LOG" info "Packages selected for $("$CONFMAN_LOG" highlight "$OPERATION"):\n$TARGET_PKGS\n"
	prompt_continuation_or_exit

	INPUT_DEVICE='/dev/tty'
	if [ "$CONFMAN_PROMPT" -eq 0 ]; then INPUT_DEVICE='/dev/null'; fi

	printf '%s\n' "$TARGET_PKGS" | while read -r PKG; do
		PRE_OP="$CONFMAN_REPO/$PKG/pre$OPERATION"
		CUSTOM_OP="$CONFMAN_REPO/$PKG/$OPERATION"
		DEFAULT_OP="$CONFMAN_REPO/default/$OPERATION"
		POST_OP="$CONFMAN_REPO/$PKG/post$OPERATION"

		if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'setup' ] && [ -f "$PRE_OP" ]; then
			execute_script "$PKG" "custom" "$PRE_OP" "$OPERATION" < "$INPUT_DEVICE"
		fi

		if [ -f "$CUSTOM_OP" ]; then
			execute_script "$PKG" "custom" "$CUSTOM_OP" "post$OPERATION" < "$INPUT_DEVICE"
		else
			execute_script "$PKG" "default" "$DEFAULT_OP" "post$OPERATION" < "$INPUT_DEVICE"
		fi

		if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'setup' ] && [ -f "$POST_OP" ]; then
			execute_script "$PKG" "custom" "$POST_OP" < /dev/tty
		fi
	done

	unset OPERATION SED_EXPR TARGET_PKGS PRE_OP CUSTOM_OP DEFAULT_OP POST_OP
}

