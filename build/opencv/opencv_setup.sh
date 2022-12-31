#!/bin/bash

# <https://docs.opencv.org/4.x/db/d05/tutorial_config_reference.html>

# for CPU_BASELINE and CPU_DISPATCH see https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options
# they should match with ones for  dldt/inference-engine/src/extension/cmake/OptimizationFlags.cmake 
#
# -DINF_ENGINE_RELEASE= should match dldt version
# See <https://github.com/opencv/dldt/issues/248#issuecomment-590102331>
# From <https://github.com/opencv/opencv/blob/c8ebe0eb86fca1c2de9de516e27be685eaba3e69/cmake/OpenCVDetectInferenceEngine.cmake#L134>
# 	"Force IE version, should be in form YYYYAABBCC (e.g. 2020.1.0.2 -> 2020010002)")

tmp=$(pwd)
ABS_PORTION=${tmp%%"/build/opencv"}

FFMPEG_PATH=$ABS_PORTION/build/ffmpeg/binaries
export LD_LIBRARY_PATH=$FFMPEG_PATH/lib/:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$FFMPEG_PATH/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_LIBDIR=$FFMPEG_PATH/lib/:$PKG_CONFIG_LIBDIR

# grep "5" from "Python 3.5.2"
PY_VER=`$ABS_PORTION/venv/bin/python3 --version | sed -rn "s/Python .\.(.)\..$/\1/p"`
PY_LIB_PATH=`find $ABS_PORTION/venv/lib/ -iname libpython3.${PY_VER}m.so`


cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D HAVE_NGRAPH=ON \
      -D WITH_WEBP=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_JPEG=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_SHARED_LIBS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_opencv_apps=OFF \
      -D BUILD_opencv_java=OFF \
      -D BUILD_opencv_python2.7=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=ON \
      -D BUILD_opencv_world=OFF \
      -D CMAKE_INSTALL_PREFIX=./binaries/ \
      -D CPU_BASELINE=SSE4_2 \
      -D CPU_DISPATCH=AVX,AVX2,FP16,AVX512 \
      -D CV_TRACE=OFF \
      -D ENABLE_CXX11=ON \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D FFMPEG_INCLUDE_DIRS=$FFMPEG_PATH/include \
      -D WITH_INF_ENGINE=ON \
      -D INF_ENGINE_INCLUDE_DIRS=$ABS_PORTION/dldt/src/inference/include \
      -D INF_ENGINE_LIB_DIRS=$ABS_PORTION/dldt/bin/intel64/Release \
      -D INF_ENGINE_RELEASE=2022030000 \
      -D INSTALL_CREATE_DISTRIB=ON \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D JPEG_INCLUDE_DIR=$JPEG_INCLUDE_DIR \
      -D JPEG_LIBRARY=$JPEG_LIBRARY \
      -D OPENCV_ENABLE_NONFREE=OFF \
      -D OPENCV_FORCE_3RDPARTY_BUILD=ON \
      -D OPENCV_SKIP_PYTHON_LOADER=ON \
      -D PYTHON3_EXECUTABLE=$ABS_PORTION/venv/bin/python3 \
      -D PYTHON3_LIBRARY:PATH=$PY_LIB_PATH \
      -D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=$ABS_PORTION/venv/lib/python3.${PY_VER}/site-packages/numpy/core/include \
      -D PYTHON3_PACKAGES_PATH=$ABS_PORTION/venv/lib/python3.${PY_VER}/site-packages \
      -D PYTHON_DEFAULT_EXECUTABLE=$ABS_PORTION/venv/bin/python3 \
      -D PYTHON_INCLUDE_DIR=/usr/include/python3.${PY_VER} \
      -D WITH_1394=OFF \
      -D WITH_CUDA=OFF \
      -D WITH_EIGEN=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_GSTRREAMER=OFF \
      -D WITH_GTK=OFF \
      -D WITH_IPP=OFF \
      -D WITH_ITT=OFF \
      -D WITH_JASPER=OFF \
      -D WITH_OPENEXR=OFF \
      -D WITH_OPENMP=OFF \
      -D WITH_PNG=ON \
      -D WITH_PROTOBUF=ON \
      -D WITH_QT=OFF \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_VTK=OFF \
      -D ngraph_DIR=$ABS_PORTION/dldt/src/core/include/ngraph ../../opencv
