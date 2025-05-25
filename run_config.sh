#!/bin/bash
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
./configure  --prefix=/opt/ffmpeg_ice --enable-rpath --disable-stripping --disable-doc \
--enable-static --disable-shared --enable-debug=3 --disable-optimizations --enable-iconv \
--enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-libmp3lame \
--enable-libxvid

make -j14

sudo make install

sudo rm -rf /opt/ffmpeg_ice/include
sudo rm -rf /opt/ffmpeg_ice/lib/*.a
sudo rm -rf /opt/ffmpeg_ice/share/ffmpeg/examples
sudo rm -rf /opt/ffmpeg_ice/lib/pkgconfig