UBUNTU_RELEASE = 23.04
DOCKER_IMAGE = yowcow/swaywm-build:ubuntu-$(UBUNTU_RELEASE)

include release.mk

all: Dockerfile
	docker build \
		--build-arg="UBUNTU_RELEASE=$(UBUNTU_RELEASE)" \
		-t $(DOCKER_IMAGE) \
		-f $< \
		.

build:
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app/wlroots \
		$(DOCKER_IMAGE) sh -c "make PKGRELEASE=$(PKGRELEASE) ARCH=$(ARCH) all build"
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app/sway \
		$(DOCKER_IMAGE) sh -c "make -C ../wlroots install && make PKGRELEASE=$(PKGRELEASE) ARCH=$(ARCH) all build"

clean:
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app \
		$(DOCKER_IMAGE) sh -c "make -C wlroots clean && make -C sway clean"

realclean:
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app \
		$(DOCKER_IMAGE) sh -c "make -C wlroots realclean && make -C sway realclean"

shell:
	docker run -it --rm \
		-v `pwd`:/app:rw \
		-w /app \
		$(DOCKER_IMAGE) bash

.PHONY: all build clean realclean shell
