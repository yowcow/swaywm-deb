IMAGE := swaywm-build

all:
	docker build -t $(IMAGE) .

checkout: wlroots/wlroots sway/sway

build: wlroots/yowcow-wlroots.deb sway/yowcow-sway.deb

wlroots/yowcow-wlroots.deb: wlroots/wlroots
	docker run --rm -it \
		-v `pwd`:/app:rw \
		-w /app/wlroots $(IMAGE) \
			make PKGVERSION=$(shell git -C $< describe --tags) PKGRELEASE=1 ARCH=amd64 clean $(notdir $@)

wlroots/wlroots:
	git clone https://gitlab.freedesktop.org/wlroots/wlroots.git $@

sway/yowcow-sway.deb: sway/sway wlroots/yowcow-wlroots.deb
	docker run --rm -it \
		-v `pwd`:/app:rw \
		-w /app/sway $(IMAGE) \
			sh -c "dpkg -i ../wlroots/yowcow-wlroots.deb && make PKGVERSION=$(shell git -C $< describe --tags) PKGRELEASE=1 ARCH=amd64 clean $(notdir $@)"

sway/sway:
	git clone git@github.com:swaywm/sway.git $@
