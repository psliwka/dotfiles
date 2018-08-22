# These paths are not covered by `20-basic-path-addons.sh` on Mac
for python_version in "2.7" "3"; do
    python=python$python_version
    is_installed $python && add_to_path "$($python -m site --user-base)/bin"
done
