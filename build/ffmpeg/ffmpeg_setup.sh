#!/bin/bash
# Maybe, prefix should contain full absolute path
# it will jelp to generate proper .pc files
../../ffmpeg/configure \
--prefix=./binaries \
--disable-static \
--enable-shared \
--disable-programs \
--disable-doc \
--disable-avdevice \
--disable-postproc \
--disable-symver \
--disable-static \
--disable-avdevice \
--disable-swresample \
--disable-postproc \
--disable-avfilter \
--disable-bzlib \
--disable-iconv \
--disable-lzma \
--disable-schannel \
--disable-sdl2 \
--disable-securetransport \
--disable-xlib \
--disable-zlib  \
--disable-audiotoolbox \
--disable-cuvid \
--disable-d3d11va \
--disable-dxva2 \
--disable-vaapi \
--disable-vdpau \
--disable-videotoolbox \
--enable-pic
