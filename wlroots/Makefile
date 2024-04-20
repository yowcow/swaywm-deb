include ../release.mk

PKGVERSION = 0.17.2
ARTIFACTS = yowcow-wlroots.$(PKGVERSION)-$(PKGRELEASE).ubuntu-$(UBUNTU_RELEASE).$(ARCH).deb
SRCDIR = wlroots
DESTDIR = /tmp/wlroots

all: PATCH = patch/wlroots-$(PKGVERSION).patch
all: $(SRCDIR)
	[ -f $(PATCH) ] && patch -p1 -N -d $< < $(PATCH) || true

$(SRCDIR): CURRENT_REVISION = $(shell git -C $@ describe --tags)
$(SRCDIR): force
	[ ! -d $@ ] && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git $@ || true;
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

realclean: clean
	rm -rf $(SRCDIR)

.PHONY: all build install clean realclean
