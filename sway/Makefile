include ../release.mk

PKGVERSION = 1.8.1
UBUNTU_RELEASE = $(shell lsb_release -rs)
ARTIFACTS = yowcow-sway.$(PKGVERSION)-$(PKGRELEASE).ubuntu-$(UBUNTU_RELEASE).$(ARCH).deb

INSTALL_DIR := /tmp/sway

all: sway

sway: CURRENT_REVISION = $(shell git -C $@ describe --tags)
sway: force
	[ ! -d $@ ] && git clone https://github.com/swaywm/sway.git $@ || true;
	[ "$(CURRENT_REVISION)" != "$(PKGVERSION)" ] && git -C $@ fetch && git -C $@ checkout $(PKGVERSION) || true;

build: $(ARTIFACTS)

%.deb: $(INSTALL_DIR) $(INSTALL_DIR)/DEBIAN/control
	dpkg-deb --build $< $@

$(INSTALL_DIR):
	cd sway \
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
