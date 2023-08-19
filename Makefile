UBUNTU_RELEASE := 23.04
DOCKER_IMAGE := swaywm-build:$(UBUNTU_RELEASE)

PKGRELEASE := 1
ARCH := amd64

all:
	docker build -t $(DOCKER_IMAGE) -f Dockerfile.ubuntu-$(UBUNTU_RELEASE) .

build:
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app/wlroots $(DOCKER_IMAGE) \
			sh -c "make PKGRELEASE=$(PKGRELEASE) ARCH=$(ARCH) all build"
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app/sway $(DOCKER_IMAGE) \
			sh -c "make -C ../wlroots install && make PKGRELEASE=$(PKGRELEASE) ARCH=$(ARCH) all build"

.PHONY: all build
