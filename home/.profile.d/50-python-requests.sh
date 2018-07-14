# Tell `requests` lib to use system-wide CA bundle instead of Certifi. This is
# useful if you have some custom CA certificates installed. For details, see
# http://docs.python-requests.org/en/stable/user/advanced/#ssl-cert-verification
#
# Beware! This bundle does not exist on Mac by default.
export REQUESTS_CA_BUNDLE=/etc/ssl/certs
