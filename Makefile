ifeq ($(ICEWEASEL_VERSION),)
$(error Specify ICEWEASEL_VERSION)
endif

ifeq ($(FLASH_VERSION),)
$(error Specify FLASH_VERSION)
endif

.PHONY: all
all:
	# Update Debian base image
	docker pull $(shell grep ^FROM Dockerfile | cut -d' ' -f2)
	# Build new version
	docker build -t capriott/debian-iceweasel:v$(ICEWEASEL_VERSION)-flash-v$(FLASH_VERSION) .
	# Tag newly created version as latest
	docker tag -f capriott/debian-iceweasel:v$(ICEWEASEL_VERSION)-flash-v$(FLASH_VERSION) capriott/debian-iceweasel:latest
	# Remove container if it is not currently running
	( docker ps | awk '$$NF=="iceweasel"{found=1} END{if(!found){exit 1}}' && echo "Please restart iceweasel manually" ) || ( docker ps -a | awk '$$NF=="iceweasel"{found=1} END{if(!found){exit 1}}' && docker rm iceweasel ) || true
