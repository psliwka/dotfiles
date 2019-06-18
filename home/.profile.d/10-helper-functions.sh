is_installed()
{
    command -v "$1" > /dev/null
}

first_installed()
{
    for candidate in "$@"; do
        if is_installed "$candidate"; then
            echo -n "$candidate"
            return
        fi
    done
}

add_to_path()
{
    if echo "$PATH" | grep -Eq "(^|:)$1(:|$)"; then
        # Directory already in PATH
        return
    fi
    export PATH="$1:$PATH"
}
