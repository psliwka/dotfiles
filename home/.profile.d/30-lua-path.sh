# https://github.com/luarocks/luarocks/wiki/Using-LuaRocks#scripts-installed-by-rocks-and-the-scripts-path
is_installed luarocks || return
add_to_path "$(luarocks path --lr-bin | cut --delimiter=: --fields=1)"
