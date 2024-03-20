include ../release.mk

PKGVERSION = 1.9
ARTIFACTS = yowcow-sway.$(PKGVERSION)-$(PKGRELEASE).ubuntu-$(UBUNTU_RELEASE).$(ARCH).deb
SRCDIR = sway
DESTDIR := /tmp/sway

all: PATCH = patch/sway-$(PKGVERSION).patch
all: $(SRCDIR)
	[ -f $(PATCH) ] && patch -p1 -N -d $< < $(PATCH) || true

$(SRCDIR): CURRENT_REVISION = $(shell git -C $@ describe --tags)
$(SRCDIR): force
	[ ! -d $@ ] && git clone https://github.com/swaywm/sway.git $@ || true;
	[ "$(CURRENT_REVISION)" != "$(PKGVERSION)" ] && git -C $@ fetch && git -C $@ checkout $(PKGVERSION) || true;

build: $(ARTIFACTS)

%.deb: $(DESTDIR) $(DESTDIR)/DEBIAN/control
	dpkg-deb --build $< $@

$(DESTDIR): $(SRCDIR)
	cd $< \
		&& meson setup build --prefix=/usr \
		&& DESTDIR=$@ ninja -C build install

$(DESTDIR)/DEBIAN/control: control
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
	rm -rf $(SRCDIR)/build $(DESTDIR) *.deb

.PHONY: all build install clean
