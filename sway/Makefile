INSTALL_DIR := /tmp/sway

all:

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

clean:
	rm -rf $(INSTALL_DIR) *.deb

.PHONY: all clean
