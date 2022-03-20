if [ -n "$SSH_CONNECTION" ] && [ -n "$SSH_AUTH_SOCK" ]; then
    # Remote client wants to forward its SSH agent, let's not interfere.
    return
fi

if [ -n "$TERMUX_VERSION" ]; then
    # On Termux https://github.com/DDoSolitary/OkcAgent is required
    is_installed okc-ssh-agent || return
    export SSH_AUTH_SOCK=$HOME/.ssh/.S_okc-agent
    pidof okc-ssh-agent > /dev/null || {
        rm -f $SSH_AUTH_SOCK
        okc-ssh-agent -a $SSH_AUTH_SOCK > /dev/null
    }
    return
fi

is_installed gpgconf || return
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
