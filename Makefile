DOCKER_IMAGE ?= 8.0-cli
TEMPLATE ?= 8.0-cli-debian
IMAGE_TAG ?= noitran/php-base:8.0-cli-debian-latest

build:
	sed -e 's/%%DOCKER_IMAGE%%/$(DOCKER_IMAGE)/g' $(TEMPLATE)/Dockerfile.template > $(TEMPLATE)/Dockerfile
	docker build -f $(TEMPLATE)/Dockerfile . -t $(IMAGE_TAG)
.PHONY: build

test:
	GOSS_FILES_PATH=$(TEMPLATE) dgoss run -t $(IMAGE_TAG)
.PHONY: test

clean:
	rm -rf */Dockerfile
.PHONY: clean

docker-push:
	docker push $(IMAGE_TAG)
.PHONY: docker-push
