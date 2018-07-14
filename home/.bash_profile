# Entrypoint for SSH and TTY logins

# Plain .profile is not sourced if .bash_profile exists.
. ~/.profile

# Launch preferred shell only when started interactively
#
# Some apps (f. ex. Xpra) expect Unix compatible shell on remote SSH host, and
# will bork if they see Fish. Keeping Bash as default noninteractive shell makes
# them happy.
if [[ -n $SHELL && $- == *i* ]]; then
    exec "$SHELL"
fi
