#!/bin/bash
if [[ -z "$ABS_PORTION" ]]; then
    echo "You forgot to:"
    echo "export ABS_PORTION=YOUR_ABSOLUTE_PATH_TO_opencv-python-inference-engine_dir"
    exit
fi


FFMPEG_PATH=$ABS_PORTION/build/ffmpeg/binaries
export LD_LIBRARY_PATH=$FFMPEG_PATH/lib/:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$FFMPEG_PATH/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_LIBDIR=$FFMPEG_PATH/lib/:$PKG_CONFIG_LIBDIR

 
# grep "5" from "Python 3.5.2"
PY_VER=`$ABS_PORTION/venv/bin/python3 --version | sed -rn "s/Python .\.(.)\..$/\1/p"`
PY_LIB_PATH=`find $ABS_PORTION/venv/lib/ -iname libpython3.${PY_VER}m.so`

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D OPENCV_FORCE_3RDPARTY_BUILD=ON \
    -D OPENCV_SKIP_PYTHON_LOADER=ON \
    -D BUILD_opencv_python3=ON \
    -D PYTHON3_EXECUTABLE=$ABS_PORTION/venv/bin/python3 \
    -D PYTHON3_LIBRARY:PATH=$PY_LIB_PATH \
    -D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=$ABS_PORTION/venv/lib/python3.${PY_VER}/site-packages/numpy/core/include \
    -D PYTHON_DEFAULT_EXECUTABLE=$ABS_PORTION/venv/bin/python3 \
    -D PYTHON3_PACKAGES_PATH=$ABS_PORTION/venv/lib/python3.${PY_VER}/site-packages \
    -D PYTHON_INCLUDE_DIR=/usr/include/python3.${PY_VER} \
    -D INSTALL_CREATE_DISTRIB=ON \
    -D ENABLE_CXX11=ON \
    -D WITH_V4L=ON \
    -D WITH_PNG=ON \
    -D WITH_FFMPEG=ON \
    -D FFMPEG_INCLUDE_DIRS=$FFMPEG_PATH/include \
    -D pkgcfg_lib_FFMPEG_avformat=$FFMPEG_PATH/lib/libavformat.so \
    -D pkgcfg_lib_FFMPEG_avcodec=$FFMPEG_PATH/lib/libavcodec.so \
    -D pkgcfg_lib_FFMPEG_avutil=$FFMPEG_PATH/lib/libavutil.so \
    -D pkgcfg_lib_FFMPEG_swscale=$FFMPEG_PATH/lib/libswscale.so \
    -D CMAKE_INSTALL_PREFIX=./binaries/ \
    -D WITH_TBB=ON \
    -D WITH_PROTOBUF=ON \
    -D JPEG_INCLUDE_DIR=$JPEG_INCLUDE_DIR \
    -D JPEG_LIBRARY=$JPEG_LIBRARY \
    -D WITH_GTK=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python2.7=OFF \
    -D BUILD_SHARED_LIBS=OFF \
    -D BUILD_opencv_world=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_opencv_java=OFF \
    -D BUILD_opencv_apps=OFF \
    -D CV_TRACE=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_DOCS=OFF \
    -D WITH_QT=OFF \
    -D ENABLE_PRECOMPILED_HEADERS=OFF \
    -D BUILD_JPEG=OFF \
    -D WITH_IPP=OFF \
    -D WITH_JASPER=OFF \
    -D WITH_WEBP=OFF \
    -D WITH_1394=OFF \
    -D WITH_GSTRREAMER=OFF \
    -D WITH_OPENEXR=OFF \
    -D WITH_OPENMP=OFF \
    -D WITH_EIGEN=OFF \
    -D WITH_VTK=OFF \
    -D BUILD_JPEG=OFF \
    -D WITH_CUDA=OFF \
    -D INF_ENGINE_INCLUDE_DIRS=$ABS_PORTION/dldt/inference-engine/include \
    -D INF_ENGINE_LIB_DIRS=$ABS_PORTION/dldt/inference-engine/bin/intel64/Release/lib \
    -D WITH_INF_ENGINE=ON ../../opencv
