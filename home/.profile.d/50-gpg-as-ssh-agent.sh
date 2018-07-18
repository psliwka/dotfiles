is_installed gpgconf || return

if [ -n "$SSH_CONNECTION" ] && [ -n "$SSH_AUTH_SOCK" ]; then
    # Remote client wants to forward its SSH agent, let's not interfere.
    return
fi

export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
