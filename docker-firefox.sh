#!/bin/bash

container_exists() {
	local container_name="$1"
	docker ps -a | awk '$NF=="'"${container_name}"'"{found=1} END{if(!found){exit 1}}'
}

set -e

xhost +local:

USER_UID=$(id -u)
USER_GID=$(id -g)
if ! container_exists storage ; then
	docker run --env=USER_UID=$USER_UID --env=USER_GID=$USER_GID --name storage capriott/docker-storage
fi

if ! container_exists firefox ; then
	exec docker run -d --env=USER_UID=$USER_UID --env=USER_GID=$USER_GID --name firefox --ipc host  --volumes-from storage --env DISPLAY="${DISPLAY}" --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro --volume=/run/user/1000/pulse:/run/pulse:ro capriott/docker-firefox
fi

exec docker start firefox
