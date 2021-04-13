# https://golang.org/doc/gopath_code#GOPATH

is_installed go || return
add_to_path "$(go env GOPATH)/bin"
