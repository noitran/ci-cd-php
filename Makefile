DOCKER_REGISTRY ?= "noitran"

.PHONY: docker-build
docker-build:
	docker build -t $(DOCKER_REGISTRY)/ci-cd-php:latest .

.PHONY: docker-push
docker-push:
	docker push $(DOCKER_REGISTRY)/ci-cd-php
