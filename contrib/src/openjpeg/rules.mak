# jpeg

OPENJPEG_VERSION := version.1.5
OPENJPEG_URL := https://github.com/uclouvain/openjpeg/archive/$(OPENJPEG_VERSION).tar.gz

$(TARBALLS)/openjpeg-$(OPENJPEG_VERSION).tar.gz:
	$(call download,$(OPENJPEG_URL))

.sum-openjpeg: openjpeg-$(OPENJPEG_VERSION).tar.gz

openjpeg: openjpeg-$(OPENJPEG_VERSION).tar.gz .sum-openjpeg
	$(UNPACK)
	$(APPLY) $(SRC)/openjpeg/freebsd.patch
ifdef HAVE_VISUALSTUDIO
	$(APPLY) $(SRC)/openjpeg/msvc.patch
endif
	$(UPDATE_AUTOCONFIG)
	$(MOVE)

.openjpeg: openjpeg
	$(RECONF)
	cd $< && $(HOSTVARS) CFLAGS="$(CFLAGS) -DOPJ_STATIC" ./configure --enable-png=no --enable-tiff=no $(HOSTCONF)
	cd $< && $(MAKE) -C libopenjpeg -j1 install
	touch $@
