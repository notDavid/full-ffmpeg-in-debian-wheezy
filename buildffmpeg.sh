#!/bin/bash

set -x

PATH="$HOME/bin:$PATH"

apt-get update && apt-get -y upgrade
apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev libmp3lame-dev wget checkinstall -y

mkdir ~/ffmpeg_sources

# Fix for bug 'checkinstall fails to create directories: https://bugs.launchpad.net/ubuntu/+source/checkinstall/+bug/815506'
sed -i -e 's/TRANSLATE=1/TRANSLATE=0/g' /etc/checkinstallrc

cd ~/ffmpeg_sources
wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure # --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install  
make distclean

cd ~/ffmpeg_sources
wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar xjvf last_x264.tar.bz2
cd x264-snapshot*
./configure --enable-static --disable-opencl
#PATH="$PATH:$HOME/bin" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --disable-opencl
make
#PATH="$PATH:$HOME/bin" make
make install
make distclean

apt-get -y install unzip
cd ~/ffmpeg_sources
wget --no-check-certificate -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
unzip fdk-aac.zip
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --disable-shared
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean

cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz
tar xzvf opus-1.1.tar.gz
cd opus-1.1
./configure --disable-shared
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean

cd ~/ffmpeg_sources
wget http://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2
tar xjvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
./configure --disable-examples
#./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean

cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
#PATH="$PATH:$HOME/bin" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  # --prefix="$HOME/ffmpeg_build" \
  #--extra-cflags="-I$HOME/ffmpeg_build/include" \
  #--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  #--bindir="$HOME/bin" \
./configure \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-nonfree \
  --enable-x11grab
#PATH="$PATH:$HOME/bin" make
make
checkinstall --install=no \
  --pkgname=ffmpeg-snapshot \
  --pkgversion=`date +%d.%m.%Y`.snapshot \
  --requires="libass-dev,libfreetype6-dev,libgpac-dev,libsdl1.2-dev,libtheora-dev,libtool,libva-dev,libvdpau-dev,libvorbis-dev,libx11-dev,libxext-dev,libxfixes-dev,texi2html,zlib1g-dev,libass-dev,libmp3lame-dev"  \
  -y make install
make distclean
hash -r

echo "# To install ffmpeg:"
echo "dpkg -i ffmpeg-snapshot_*.snapshot-1_amd64.deb"
echo "# Now you might get an error message about dependency problems / missing dependencies:"
echo "# If so, to install the missing dependencies:"
echo "apt-get -f install"
