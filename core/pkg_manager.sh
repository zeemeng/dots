#!/usr/bin/env sh

# If PKG_MANAGER is initially empty, set a default value if appropriate
select_default_pkg_manager() {
	SUPPORTED_PKG_MANAGER="apt pacman brew"

	[ -n "$PKG_MANAGER" ] && echo "$PKG_MANAGER" && return
	for MGR in $SUPPORTED_PKG_MANAGER; do
		command -v "$MGR" >/dev/null 2>&1 && printf "$MGR" && return
	done
}

# If PKG_MANAGER does not denote an invocable command, notify and exit
validate_pkg_manager() {
	! command -v "$PKG_MANAGER" >/dev/null 2>&1 &&
		echo "ERROR: No suitable package manager was found." >&2 &&
		exit 1
}

# Update/sync back-end package manager repositories with external sources. Set options and environment variables
init_pkg_manager() {
	[ "$PKG_MANAGER" = "apt" ] && sudo apt update && return
	
	[ "$PKG_MANAGER" = "pacman" ] && sudo pacman -Sy && return
	
	if [ "$PKG_MANAGER" = "brew" ]; then
		# Do not run `brew update --auto-update` before certain operations such as install
		export HOMEBREW_NO_AUTO_UPDATE=1

		# Update/sync homebrew repositories
		brew update
	fi
}

