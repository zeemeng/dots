#!/usr/bin/env sh

SETDOTS_RED='\033[1;31m'
SETDOTS_GREEN='\033[0;32m'
SETDOTS_YELLOW='\033[0;33m'
SETDOTS_BLUE='\033[0;36m'
SETDOTS_NC='\033[0m' # No Color
SETDOTS_PREFIX_NORMAL='SETDOTS: '
SETDOTS_PREFIX_WARNING='WARNING: '
SETDOTS_PREFIX_ERROR='ERROR: '

log_info() {
	printf "${SETDOTS_BLUE}${SETDOTS_PREFIX_NORMAL}${SETDOTS_NC}$*\n"
}

log_success() {
	printf "${SETDOTS_GREEN}${SETDOTS_PREFIX_NORMAL}$*${SETDOTS_NC}\n"
}

log_warning() {
	printf "${SETDOTS_YELLOW}${SETDOTS_PREFIX_WARNING}$*${SETDOTS_NC}\n" >&2
}

log_error() {
	printf "${SETDOTS_RED}${SETDOTS_PREFIX_ERROR}$*${SETDOTS_NC}\n" >&2
}

highlight_string() {
	printf "${SETDOTS_BLUE}$*${SETDOTS_NC}"
}

print_usage_exit() {
	cat <<- EOF
	USAGE:
	setdots [-iIs] [-f package_list] [-m manager] [-p n] [package ...]
	setdots [-uUr] [-f package_list] [-m manager] [-p n] [package ...]
	setdots [-l] [-f package_list] [package ...]
	setdots [-vhH] 

	EOF
	exit 1
}

print_version_exit() {
	printf "setdots v0.1\n"
	exit 0
}

show_manpage_exit() {
	man "$SETDOTS_DIR/manpage/roff/setdots.1"
	exit 0
}

print_exit_invalid_options_combination() {
	log_error "Options -i, -I, and -s cannot be used in conjunction with options -u, -U, or -r"
	exit 1
}

seek_optional_confirmation() {
	# If SETDOTS_PROMPT is level 1 or level 2
	if [ "$SETDOTS_PROMPT" -ge 1 ]; then
		printf 'Are you sure you want to continue? (y)es / (n)o: '
		read RESPONSE
		case "$RESPONSE" in
			Y*|y*) printf '\n'; return 0;;
			*) log_error 'Aborting..'; exit 1;;
		esac

		unset RESPONSE
	fi
}

append_to_selected_pkgs() {
	# Expecting pre-defined variables: PKG_REPO, PKG, SELECTED_PKGS, NEW_LINE

	# Check if PKG contains any non-whitespace character. If it does, continue, otherwise return
	echo "$PKG" | grep -q "[^[:space:]]" || return

	# Add PKG to SELECTED_PKGS on a new line, suffixed with ":nis"
	if [ -f "$PKG_REPO/$PKG/noinstall" ] && [ -f "$PKG_REPO/$PKG/nosetup" ]; then
		SELECTED_PKGS="${SELECTED_PKGS}${NEW_LINE}${PKG}:nis"
		return
	fi

	# Add PKG to SELECTED_PKGS on a new line, suffixed with ":ni"
	if [ -f "$PKG_REPO/$PKG/noinstall" ]; then
		SELECTED_PKGS="${SELECTED_PKGS}${NEW_LINE}${PKG}:ni"
		return
	fi

	# Add PKG to SELECTED_PKGS on a new line, suffixed with ":ns"
	if [ -f "$PKG_REPO/$PKG/nosetup" ]; then
		SELECTED_PKGS="${SELECTED_PKGS}${NEW_LINE}${PKG}:ns"
		return
	fi

	# Add PKG to SELECTED_PKGS on a new line, suffixed with ":is"
	if [ -d "$PKG_REPO/$PKG" ]; then
		SELECTED_PKGS="${SELECTED_PKGS}${NEW_LINE}${PKG}:is"
		return
	fi
}

read_selected_packages() {
	SELECTED_PKGS=""; NEW_LINE="
"
	# Select packages from operands
	for PKG in "$@"; do append_to_selected_pkgs; done

	# If specified file exists and can be read, select packages from file line-by-line
	if [ -f "$f" ] && [ -r "$f" ]; then
		while read PKG; do append_to_selected_pkgs; done < "$f"

	# Specified file exists, but cannot be read
	elif [ "$f" ]; then
		log_warning "Cannot read package list file. Defaulting to select all packages from repository."
		seek_optional_confirmation
	fi

	# If no operand and no package-list file is specified, select all packages from the target package repository
	if [ "$#" -eq 0 ] && [ ! "$f" ]; then
		while read PKG; do
			if [ "default" != "$PKG" ]; then append_to_selected_pkgs; fi
		done <<-EOF
		$(ls -1A "$PKG_REPO")
		EOF
	fi

	# Sort and remove duplicate items in SELECTED_PKGS
	SELECTED_PKGS="$(echo "$SELECTED_PKGS" | sort -u)"
}

print_exit_selected_packages() {
	NO_SUFFIX="$(echo "$SELECTED_PKGS" | sed -n 's/:..$//p; s/:nis$//p')"

	# Print header
	printf "%-20s%-20s%-20s%-20s%-20s\n" "Package Name" "Install" "Uninstall" "Configure" "RM Config"
	printf "=========================================================================================\n"

	printf "$NO_SUFFIX\n" | while read PKG; do
		# "Package Name" column
		printf "%-20s" "$PKG"

		# "Install" and "Uninstall" columns
		INSTALL_COLUMN=""; UNINSTALL_COLUMN=""; # Reset vars for each iteration
		if [ -f "$PKG_REPO/$PKG/noinstall" ]; then
			INSTALL_COLUMN="NO INSTALL"
		else
			if [ -f "$PKG_REPO/$PKG/install" ]; then INSTALL_COLUMN="CUSTOM"; else INSTALL_COLUMN="DEFAULT"; fi
			if [ -f "$PKG_REPO/$PKG/preinstall" ]; then INSTALL_COLUMN="${INSTALL_COLUMN}, PRE"; fi
			if [ -f "$PKG_REPO/$PKG/postinstall" ]; then INSTALL_COLUMN="${INSTALL_COLUMN}, POST"; fi

			if [ -f "$PKG_REPO/$PKG/uninstall" ]; then UNINSTALL_COLUMN="CUSTOM"; else UNINSTALL_COLUMN="DEFAULT"; fi
		fi
		printf "%-20s%-20s" "$INSTALL_COLUMN" "$UNINSTALL_COLUMN"

		# "Configure" and "RM Config" column
		CONFIG_COLUMN="";RM_CONFIG_COLUMN=""; # Reset vars for each iteration
		if [ -f "$PKG_REPO/$PKG/nosetup" ]; then
			CONFIG_COLUMN="NO SETUP"
		else
			if [ -f "$PKG_REPO/$PKG/setup" ]; then CONFIG_COLUMN="CUSTOM"; else CONFIG_COLUMN="DEFAULT"; fi
			if [ -f "$PKG_REPO/$PKG/presetup" ]; then CONFIG_COLUMN="${CONFIG_COLUMN}, PRE"; fi
			if [ -f "$PKG_REPO/$PKG/postsetup" ]; then CONFIG_COLUMN="${CONFIG_COLUMN}, POST"; fi

			if [ -f "$PKG_REPO/$PKG/unset" ]; then RM_CONFIG_COLUMN="CUSTOM"; else RM_CONFIG_COLUMN="DEFAULT"; fi
		fi
		printf "%-20s%-20s" "$CONFIG_COLUMN" "$RM_CONFIG_COLUMN"

		printf "\n"
	done
}

execute_script() (
	export PKG="$1" # Desc: package name
	DEFAULT_OR_CUSTOM="$2" # Values: 'default' | 'custom'
	SCRIPT="$3" # Desc: path to the file to execute
	NEXT_OPERATION="$4" # Desc: Name of the subsequent operation to be performed
	SCRIPT_NAME="$(basename "$SCRIPT")"

	log_info "Performing $DEFAULT_OR_CUSTOM $(highlight_string "$SCRIPT_NAME") for $(highlight_string "$PKG")"

	if [ ! -x "$SCRIPT" ]; then
		log_warning "Adding execute permission to $DEFAULT_OR_CUSTOM \"$SCRIPT_NAME\" file for \"$PKG\""
		if ! chmod ug+x "$SCRIPT" 2>/dev/null; then
			log_warning "User '$(whoami)' does not have permission to 'chmod' file '$SCRIPT'. Requesting 'chmod ug+x' on file with 'sudo'.."
			sudo chmod ug+x "$SCRIPT"
		fi
	fi

	# Invoke the specified script as a command to enable execution by a different interpreter or as a standalone executable
	if "$SCRIPT"; then
		log_success "SUCCESSFULLY performed $DEFAULT_OR_CUSTOM \"$SCRIPT_NAME\" for \"$PKG\"\n"
	else
		log_error "An error occured during $DEFAULT_OR_CUSTOM \"$SCRIPT_NAME\" for \"$PKG\""
		if [ "$NEXT_OPERATION" ]; then log_error "Skipping \"$NEXT_OPERATION\" for \"$PKG\""; fi
		printf '\n'
	fi
)

dispatch_operations() {
	OPERATION="$1" # Values: 'install' | 'setup' | 'uninstall' | 'unset'

	# Update/sync back-end package manager repositories. Set options and environment variables
	if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'uninstall' ]; then init_pkg_manager; fi

	# Find packages suitable for the target operation among SELECTED_PKGS
	if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'uninstall' ]; then
		SED_EXPR='s/:is$//p; s/:ns$//p'
	else # For OPERATION == 'setup' | 'unset'
		SED_EXPR='s/:is$//p; s/:ni$//p'
	fi

	TARGET_PKGS="$(echo "$SELECTED_PKGS" | sed -n "$SED_EXPR")"
	if [ -z "$TARGET_PKGS" ]; then return; fi

	log_info "Packages selected for $(highlight_string "$OPERATION"):\n$TARGET_PKGS\n"
	seek_optional_confirmation

	echo "$TARGET_PKGS" | while read PKG; do
		PRE_OP="$PKG_REPO/$PKG/pre$OPERATION" 
		CUSTOM_OP="$PKG_REPO/$PKG/$OPERATION"
		DEFAULT_OP="$PKG_REPO/default/$OPERATION"
		POST_OP="$PKG_REPO/$PKG/post$OPERATION"

		if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'setup' ] && [ -f "$PRE_OP" ]; then
			execute_script "$PKG" "custom" "$PRE_OP" "$OPERATION" < /dev/tty
		fi

		if [ -f "$CUSTOM_OP" ]; then
			execute_script "$PKG" "custom" "$CUSTOM_OP" "post$OPERATION" < /dev/tty
		else
			execute_script "$PKG" "default" "$DEFAULT_OP" "post$OPERATION" < /dev/tty
		fi

		if [ "$OPERATION" = 'install' ] || [ "$OPERATION" = 'setup' ] && [ -f "$POST_OP" ]; then
			execute_script "$PKG" "custom" "$POST_OP" < /dev/tty
		fi
	done

	unset OPERATION SED_EXPR TARGET_PKGS PRE_OP CUSTOM_OP DEFAULT_OP POST_OP 
}

