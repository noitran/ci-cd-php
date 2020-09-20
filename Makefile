DOCKER_IMAGE ?= 7.4-fpm
TEMPLATE ?= 7.4-fpm-debian
IMAGE_TAG ?= noitran/php:7.4-fpm-debian-latest

build:
	sed -e 's/%%DOCKER_IMAGE%%/$(DOCKER_IMAGE)/g' $(TEMPLATE)/Dockerfile.template > $(TEMPLATE)/Dockerfile
	docker build -t $(IMAGE_TAG) $(TEMPLATE)
.PHONY: build

test:
	GOSS_FILES_PATH=$(TEMPLATE) dgoss run -t $(IMAGE_TAG)
.PHONY: test

clean:
	rm -rf */Dockerfile
.PHONY: clean
