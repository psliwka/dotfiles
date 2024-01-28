# NB `TASKWARRIOR_DATA_LOCATION` is not a standard env var recognized by
# Taskwarrior – it's explicitly referenced by `~/.config/task/taskrc`.
# Theoretically `TASKDATA` could be used here, but it causes Taskwarrior to
# print an annoying 'TASKDATA override' warning on each invocation.
if [ -n "$TERMUX_VERSION" ]; then
	export TASKWARRIOR_DATA_LOCATION=~/storage/shared/Taskwarrior/
else
	export TASKWARRIOR_DATA_LOCATION=~/.local/share/task/
fi
