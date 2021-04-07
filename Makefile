all: build

build: compress
	chmod -Rv 644 build/contrib/
	fpm -s dir -f -t deb \
		-n blackbox_exporter \
		-v $(VERSION) \
		--iteration $(ITERATION) \
		--after-install build/contrib/blackbox_exporter.postinstall \
		--after-remove build/contrib/blackbox_exporter.postrm \
		-p build/packages \
		build/contrib/blackbox_exporter.service=/lib/systemd/system/blackbox_exporter.service \
		build/contrib/blackbox_exporter.defaults=/etc/default/blackbox_exporter \
		build/contrib/blackbox_exporter.preset=/usr/lib/systemd/system-preset/blackbox_exporter.preset \
		/tmp/blackbox_exporter/blackbox_exporter=/usr/bin/blackbox_exporter \
		/tmp/blackbox_exporter/blackbox.yml=/etc/blackbox.yml

compress: download
	upx /tmp/blackbox_exporter/blackbox_exporter

download:
	cd /tmp && curl -Lo blackbox_exporter.tar.gz https://github.com/prometheus/blackbox_exporter/releases/download/v$(VERSION)/blackbox_exporter-$(VERSION).linux-amd64.tar.gz
	cd /tmp && tar -xvzf /tmp/blackbox_exporter.tar.gz && mv blackbox_exporter-$(VERSION).linux-amd64 blackbox_exporter
