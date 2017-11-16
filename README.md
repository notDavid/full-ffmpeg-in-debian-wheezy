full-ffmpeg-in-debian-wheezy
============================

Build, create .deb &amp; install full ffmpeg in debian wheezy - optionally using docker

	git clone git://github.com/notDavid/full-ffmpeg-in-debian-wheezy.git
	cd full-ffmpeg-in-debian-wheezy/
	docker build -t="ffmpeg-build" .
	# on the host:
	mkdir -p ~/tmp && docker run -t -i -v ~/tmp:/data ffmpeg-build bash
	# in the container:
	cp ~/ffmpeg_sources/ffmpeg/ffmpeg-snapshot_*.deb /data/
	exit
	# on the host, to install
	dpkg -i ~/tmp/ffmpeg-snapshot_*.snapshot-1_amd64.deb