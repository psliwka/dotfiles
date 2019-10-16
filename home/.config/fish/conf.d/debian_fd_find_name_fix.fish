# In Debian, https://github.com/sharkdp/fd is renamed to `fdfind`, to avoid
# name clash with `fdclone`. Let's fix this.

if not type -q fd; and type -q fdfind
  function fd --wraps=fdfind --description='Find entries in the filesystem'
    fdfind $argv
  end
end
