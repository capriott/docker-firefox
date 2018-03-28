ifeq ($(FIREFOX_VERSION),)
FIREFOX_VERSION = 59.0.2-1
endif

ifeq ($(FLASH_VERSION),)
FLASH_VERSION = 29.0.0.113
endif

.PHONY: all
all:
	# Update Debian base image
	docker pull $(shell grep ^FROM Dockerfile | cut -d' ' -f2)
	# Build new version
	docker build -t capriott/docker-firefox:v$(FIREFOX_VERSION)-flash-v$(FLASH_VERSION) .
	# Tag newly created version as latest
	docker tag capriott/docker-firefox:v$(FIREFOX_VERSION)-flash-v$(FLASH_VERSION) capriott/docker-firefox:latest
	# Remove container if it is not currently running
	( docker ps | awk '$$NF=="firefox"{found=1} END{if(!found){exit 1}}' && echo "Please restart firefox manually" ) || ( docker ps -a | awk '$$NF=="firefox"{found=1} END{if(!found){exit 1}}' && docker rm firefox ) || true
