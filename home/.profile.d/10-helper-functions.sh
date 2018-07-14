is_installed()
{
    command -v "$1" > /dev/null
    return $?
}

add_to_path()
{
    if echo "$PATH" | grep -Eq "(^|:)$1(:|$)"; then
        # Directory already in PATH
        return
    fi
    export PATH="$1:$PATH"
}
