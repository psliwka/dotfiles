# https://guides.rubygems.org/faqs/#user-install
is_installed ruby && is_installed gem || return
add_to_path "$(ruby -r rubygems -e 'puts Gem.user_dir')"
