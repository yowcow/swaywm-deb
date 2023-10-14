PKGRELEASE = 2
UBUNTU_RELEASE = $(shell lsb_release -rs)
PROCESSOR = $(shell uname -p)

ifeq ($(PROCESSOR),x86_64)
ARCH = amd64
else
ARCH = $(PROCESSOR)
endif
