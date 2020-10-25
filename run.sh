#!/bin/bash
export TTY

slugify() {
    sed -r "s/[^a-zA-Z0-9]+/-/g" | sed -r "s/^-+\|-+$//g" | tr A-Z a-z
}

# TODO Use elisp instead
# cd "$(vc get-top-level)"

# TODO Select emacs program based on name

sn="$(basename "$0")"

case "$sn" in
    magit) {
        ic=magit-status
    }
    ;;

    edocker) {
        ic=docker
    }
    ;;

    *)
esac
: "${ic:="magit-status"}"

# TODO Create an ssh control socket and use it to run docker on the host
# ssh to the localhost

user="$(whoami)"

docker \
    run \
    --env "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" \
    --env DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
    --env "DISPLAY=:0" \
    --privileged \
    --network=host \
    --rm \
    -v \
    ~/.gitconfig:/root/.gitconfig \
    -v \
    ~/.authinfo:/root/.authinfo \
    -v \
    ~/.gitcredentials:/root/.gitcredentials \
    -v \
    "$(pwd):/$(pwd | slugify)" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w \
    "/$(pwd | slugify)" \
    -ti \
    --entrypoint= \
    vlandeiro-magit-docker-030d5134:1.0 \
    /entry.sh "$ic"