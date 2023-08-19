include ../release.mk

PKGVERSION = 0.16.2
UBUNTU_RELEASE = $(shell lsb_release -rs)
ARTIFACTS = yowcow-wlroots.$(PKGVERSION)-$(PKGRELEASE).ubuntu-$(UBUNTU_RELEASE).$(ARCH).deb

INSTALL_DIR := /tmp/wlroots

all: wlroots

wlroots: CURRENT_REVISION = $(shell git -C $@ describe --tags)
wlroots: force
	[ ! -d $@ ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git $@ || true;
	[ "$(CURRENT_REVISION)" != "$(PKGVERSION)" ] && git -C $@ fetch && git -C $@ checkout $(PKGVERSION) || true;

build: $(ARTIFACTS)

%.deb: $(INSTALL_DIR) $(INSTALL_DIR)/DEBIAN/control
	dpkg-deb --build $< $@

$(INSTALL_DIR):
	cd wlroots \
		&& meson setup build --prefix=/usr \
		&& DESTDIR=$@ ninja -C build install

$(INSTALL_DIR)/DEBIAN/control: control
	mkdir -p $(dir $@)
	cat $< \
		| sed -e 's/{{PKGVERSION}}/$(PKGVERSION)/g' \
		| sed -e 's/{{PKGRELEASE}}/$(PKGRELEASE)/g' \
		| sed -e 's/{{ARCH}}/$(ARCH)/g' \
		> $@

install: $(ARTIFACTS)
	dpkg -i $^

force:

clean:
	rm -rf $(INSTALL_DIR) *.deb

.PHONY: all build install clean
