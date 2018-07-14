# Common part of all profiles, split into multiple files under ~/.profile.d
#
# On many systems, it is processed by plain Unix shell - no bashisms allowed.

for PROFILE_CHUNK in ~/.profile.d/*.sh; do
    . $PROFILE_CHUNK
done
