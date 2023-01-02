#!/bin/bash

# https://github.com/openvinotoolkit/openvino/wiki/CMakeOptionsForCustomCompilation
# apt install cython cmake patchelf
cmake -D THREADING=TBB \
      -D CMAKE_BUILD_TYPE=Release \
      -D ENABLE_FASTER_BUILD=ON \
      -D ENABLE_LTO=ON \
      -D ENABLE_SSE42=ON \
      -D ENABLE_AVX2=ON \
      -D ENABLE_AVX512F=OFF \
      -D ENABLE_DOCS=OFF \
      -D ENABLE_GAPI_TESTS=OFF \
      -D ENABLE_OPENCV=ON \
      -D ENABLE_PROFILING_ITT=OFF \
      -D ENABLE_PYTHON=ON \
      -D ENABLE_WHEEL=OFF \
      -D ENABLE_SAMPLES=OFF \
      -D ENABLE_TESTS=OFF \
      -D ENABLE_INTEL_GNA=OFF \
      -D ENABLE_INTEL_MYRIAD=ON \
      -D ENABLE_INTEL_MYRIAD_COMMON=ON \
      -D ENABLE_OV_ONNX_FRONTEND=ON \
      -D ENABLE_OV_TF_FRONTEND=ON \
      -D ENABLE_OV_IR_FRONTEND=ON \
      -D BUILD_TESTING=OFF \
      -D ENABLE_GAPI_PREPROCESSING=OFF \
      -D ENABLE_TEMPLATE=ON \
      -D SELECTIVE_BUILD=OFF ../../dldt/
