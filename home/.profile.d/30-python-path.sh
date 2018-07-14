is_installed python || return

# This path is not covered by `20-basic-path-addons.sh` on Mac
add_to_path "$(python -m site --user-base)/bin"
