# Compilation hors arbre du pilote ath9k (Linux 6.8) avec les ajouts du labo.
KVER ?= $(shell uname -r)
KDIR ?= /lib/modules/$(KVER)/build
SRC  := $(CURDIR)/ath/ath9k
VER  := $(shell sed -n 's/^PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)

modules:
	$(MAKE) -C $(KDIR) M=$(SRC) modules

clean:
	$(MAKE) -C $(KDIR) M=$(SRC) clean

dkms_install:
	rm -rf /usr/src/ath9k-htc-lab-$(VER)
	mkdir -p /usr/src/ath9k-htc-lab-$(VER)
	cp -r Makefile dkms.conf ath /usr/src/ath9k-htc-lab-$(VER)/
	dkms add -m ath9k-htc-lab -v $(VER)
	dkms build -m ath9k-htc-lab -v $(VER)
	dkms install -m ath9k-htc-lab -v $(VER) --force

dkms_remove:
	-dkms remove ath9k-htc-lab/$(VER) --all
	rm -rf /usr/src/ath9k-htc-lab-$(VER)

.PHONY: modules clean dkms_install dkms_remove
