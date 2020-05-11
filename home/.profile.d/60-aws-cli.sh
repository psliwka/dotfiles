# Needed due to https://github.com/aws/aws-cli/issues/3425

if [ -n "$REQUESTS_CA_BUNDLE" ]; then
    export AWS_CA_BUNDLE="$REQUESTS_CA_BUNDLE/ca-certificates.crt"
fi
