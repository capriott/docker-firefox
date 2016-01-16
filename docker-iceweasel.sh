#!/bin/bash

container_exists() {
	local container_name="$1"
	docker ps -a | awk '$NF=="'"${container_name}"'"{found=1} END{if(!found){exit 1}}'
}

set -e

xhost +local:

if ! container_exists storage ; then
	docker run --name storage capriott/docker-storage
fi

if ! container_exists iceweasel ; then
	declare -a dri_devices
	for d in `find /dev/dri -type c` ; do
		dri_devices+=(--device "${d}")
	done
	exec docker run --name iceweasel --volumes-from storage --env DISPLAY="${DISPLAY}" --volume /tmp/.X11-unix:/tmp/.X11-unix "${dri_devices[@]}" --device /dev/snd capriott/docker-iceweasel
fi

exec docker start iceweasel
