UBUNTU_RELEASE := 23.04
DOCKER_IMAGE := swaywm-build:$(UBUNTU_RELEASE)

SWAY_REVISION := 1.8.1
WLROOTS_REVISION := 0.16.2
PKGRELEASE := 0
ARCH := amd64
SUFFIX := ubuntu-$(UBUNTU_RELEASE).$(ARCH).deb

ARTIFACTS := wlroots/yowcow-wlroots.$(WLROOTS_REVISION)-$(PKGRELEASE).$(SUFFIX) sway/yowcow-sway.$(SWAY_REVISION)-$(PKGRELEASE).$(SUFFIX)

all:
	docker build -t $(DOCKER_IMAGE) -f Dockerfile.ubuntu-$(UBUNTU_RELEASE) .

wlroots/wlroots: CURRENT_WLROOTS_REVISION = $(shell git -C $@ describe --tags)
wlroots/wlroots: force
	[ ! -d $@ ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git $@ || true;
	[ "$(CURRENT_WLROOTS_REVISION)" != "$(WLROOTS_REVISION)" ] && git -C $@ fetch && git -C $@ checkout $(WLROOTS_REVISION) || true;

sway/sway: CURRENT_SWAY_REVISION = $(shell git -C $@ describe --tags)
sway/sway: force
	[ ! -d $@ ] && git clone git@github.com:swaywm/sway.git $@ || true;
	[ "$(CURRENT_SWAY_REVISION)" != "$(SWAY_REVISION)" ] && git -C $@ fetch && git -C $@ checkout $(SWAY_REVISION) || true;

build: $(ARTIFACTS)

clean:
	rm -rf $(ARTIFACTS)

realclean: clean
	docker rmi $(DOCKER_IMAGE)

wlroots/yowcow-wlroots.$(WLROOTS_REVISION)-$(PKGRELEASE).$(SUFFIX): wlroots/wlroots
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app/wlroots $(DOCKER_IMAGE) \
			make PKGVERSION=$(WLROOTS_REVISION) PKGRELEASE=$(PKGRELEASE) ARCH=$(ARCH) $(notdir $@)

sway/yowcow-sway.$(SWAY_REVISION)-$(PKGRELEASE).$(SUFFIX): wlroots/yowcow-wlroots.$(WLROOTS_REVISION)-$(PKGRELEASE).$(SUFFIX) sway/sway
	docker run --rm \
		-v `pwd`:/app:rw \
		-w /app/sway $(DOCKER_IMAGE) \
			sh -c "dpkg -i ../$< && make PKGVERSION=$(SWAY_REVISION) PKGRELEASE=$(PKGRELEASE) ARCH=$(ARCH) $(notdir $@)"

force:

.PHONY: all build clean realclean
