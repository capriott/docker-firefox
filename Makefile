ifeq ($(ICEWEASEL_VERSION),)
ICEWEASEL_VERSION = 44.0.2-1
endif

ifeq ($(FLASH_VERSION),)
FLASH_VERSION = 11.2.202.569
endif

.PHONY: all
all:
	# Update Debian base image
	docker pull $(shell grep ^FROM Dockerfile | cut -d' ' -f2)
	# Build new version
	docker build -t capriott/docker-iceweasel:v$(ICEWEASEL_VERSION)-flash-v$(FLASH_VERSION) .
	# Tag newly created version as latest
	docker tag -f capriott/docker-iceweasel:v$(ICEWEASEL_VERSION)-flash-v$(FLASH_VERSION) capriott/docker-iceweasel:latest
	# Remove container if it is not currently running
	( docker ps | awk '$$NF=="iceweasel"{found=1} END{if(!found){exit 1}}' && echo "Please restart iceweasel manually" ) || ( docker ps -a | awk '$$NF=="iceweasel"{found=1} END{if(!found){exit 1}}' && docker rm iceweasel ) || true
