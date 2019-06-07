#!/bin/bash
# --enable-libx264
# --enable-libopenh264 \
# --enable-gpl --enable-libx264 \
../../ffmpeg/configure \
--prefix=./binaries \
--disable-programs \
--disable-avdevice \
--disable-postproc \
--disable-symver \
--disable-static \
--disable-avdevice --disable-swresample \
--disable-postproc --disable-avfilter \
--disable-alsa --disable-appkit \
--disable-avfoundation --disable-bzlib \
--disable-coreimage --disable-iconv \
--disable-lzma \
--disable-sndio --disable-schannel --disable-sdl2 \
--disable-securetransport \
--disable-xlib --disable-zlib  \
--disable-audiotoolbox --disable-amf --disable-cuvid --disable-d3d11va \
--disable-dxva2 --disable-ffnvcodec --disable-nvdec --disable-nvenc \
--disable-v4l2-m2m --disable-vaapi --disable-vdpau --disable-videotoolbox \
--disable-doc --disable-static \
--enable-pic --enable-shared
