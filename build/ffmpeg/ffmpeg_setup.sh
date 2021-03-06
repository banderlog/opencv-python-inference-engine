#!/bin/bash
# deprecated: --enable-avresample , switch to libswresample
# The libswresample library performs highly optimized audio resampling,
#   rematrixing and sample format conversion operations. 

PATH_TO_SCRIPT=`dirname $(realpath $0)`

../../ffmpeg/configure \
--prefix=$PATH_TO_SCRIPT/binaries \
--disable-programs \
--disable-avdevice \
--disable-postproc \
--disable-static \
--disable-avdevice \
--disable-swresample \
--disable-postproc \
--disable-avfilter \
--disable-alsa \
--disable-appkit \
--disable-avfoundation \
--disable-bzlib \
--disable-coreimage \
--disable-iconv \
--disable-lzma \
--disable-sndio \
--disable-schannel \
--disable-sdl2 \
--disable-securetransport \
--disable-xlib \
--disable-zlib  \
--disable-audiotoolbox \
--disable-amf \
--disable-cuvid \
--disable-d3d11va \
--disable-dxva2 \
--disable-ffnvcodec \
--disable-nvdec \
--disable-nvenc \
--disable-v4l2-m2m \
--disable-vaapi \
--disable-vdpau \
--disable-videotoolbox \
--disable-doc \
--disable-static \
--enable-pic \
--enable-shared \
