
WWW_UPLOAD_URI = elrond:/home/hanke/public_html/archive
WWW_DIR = build/html

all: html

prep:
	if [ ! -d build ]; then mkdir build; fi
	rsync -rvlhp sphinx/ build/src


pics:
	$(MAKE) -C artwork


html: html-stamp
html-stamp: pics prep source
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build
	touch $@


clean:
	-rm -rf build
	$(MAKE) -C artwork clean



distclean: clean
	-rm -rf cache


source: source-stamp
source-stamp: build/db.db
	tools/reblender generate \
		--cfg debneuro.cfg \
		--db build/db.db \
		--outdir build/src \
		--pkgaddenum pkgs
	rm -f html-stamp
	touch $@


build/db.db:
	mkdir -p build
	tools/reblender refreshdb \
		--cfg debneuro.cfg \
		--db build/db.db


upload-website: html
	rsync -rvzlhp --delete --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)

.PHONY: prep