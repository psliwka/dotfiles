is_installed gpgconf || return

export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
