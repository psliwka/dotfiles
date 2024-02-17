function fish_title
    # If we're connected via ssh, we print the hostname.
    if set -q SSH_TTY
        prompt_hostname
        echo -n ':'
    end

    prompt_pwd -d 0 -D 0

    test (id -u) -eq 0; and echo -n ' # '; or echo -n ' $ '

    # An override for the current command is passed as the first parameter.
    # This is used by `fg` to show the true process name, among others.
    if set -q argv[1]
        echo -n $argv[1]
    end
end
