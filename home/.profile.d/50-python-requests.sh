# Tell `requests` lib to use system-wide CA bundle instead of Certifi. This is
# useful if you have some custom CA certificates installed. For details, see
# http://docs.python-requests.org/en/stable/user/advanced/#ssl-cert-verification

case "$(uname)" in
    Linux)
        export REQUESTS_CA_BUNDLE=/etc/ssl/certs
        ;;
    Darwin)
        # Does not exist on Mac by default, created by `$ brew install openssl`
        # Remember to run `$HOMEBREW_PREFIX/opt/openssl@3/bin/c_rehash` after
        # you drop new certificates there.
        export REQUESTS_CA_BUNDLE=$HOMEBREW_PREFIX/etc/ca-certificates/cert.pem
        ;;
esac
