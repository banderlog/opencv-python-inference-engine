#!/bin/bash

# GEMM (General matrix-matrix multiplication)
#
# -D BUILD_SHARED_LIBS=ON always crash

tmp=$(pwd)
BLAS_LIB="${tmp%dldt}openblas/lib/libopenblas.so.0"
BLAS_INC="${tmp%dldt}openblas/include/openblas"

#if [ ! -f $BLAS_LIB ] || [ ! -d $BLAS_INC ]; then
#    echo "!!! Check paths for openblas lib !!!"
#    echo "I tried: $BLAS_LIB and $BLAS_INC"
#    exit
#fi

# <https://github.com/openvinotoolkit/openvino/issues/4527>
# look for proper values at <https://download.01.org/opencv/master/openvinotoolkit/thirdparty/linux/opencv/>
# calculate hash256 manually
#patch ../../dldt/inference-engine/cmake/dependencies.cmake dependencies.patch


# Manually-specified variables were not used by the project:
# -D ENABLE_NGRAPH=ON \
cmake -D CMAKE_BUILD_TYPE=Release \
      -D ENABLE_LTO=ON \
      -D GEMM=JIT \
      -D THREADING=TBB \
      -D ENABLE_VPU=ON \
      -D ENABLE_MYRIAD=ON \
      -D ENABLE_OPENCV=OFF \
      -D ENABLE_MKL_DNN=ON \
      -D BUILD_SHARED_LIBS=OFF \
      -D BUILD_TESTS=OFF \
      -D ENABLE_PYTHON=OFF \
      -D ENABLE_TESTS=OFF \
      -D ENABLE_DOCS=OFF \
      -D ENABLE_SAMPLES=OFF \
      -D ENABLE_GAPI_TESTS=OFF \
      -D GAPI_TEST_PERF=OFF \
      -D ENABLE_GNA=OFF \
      -D ENABLE_PROFILING_ITT=OFF \
      -D ENABLE_ALTERNATIVE_TEMP=OFF \
      -D ENABLE_SSE42=ON \
      -D ENABLE_AVX2=ON \
      -D ENABLE_AVX512F=OFF \
      -D NGRAPH_UNIT_TEST_ENABLE=OFF \
      -D NGRAPH_TEST_UTIL_ENABLE=OFF \
      -D NGRAPH_ONNX_IMPORT_ENABLE=ON \
      -D BLAS_LIBRARIES="$BLAS_LIB" \
      -D BLAS_INCLUDE_DIRS="$BLAS_INC" \
      -D ENABLE_CLDNN=OFF \
      -D ENABLE_CLDNN_TESTS=OFF \
      -D ENABLE_PROFILING_ITT=OFF \
      -D SELECTIVE_BUILD=OFF \
      -D ENABLE_SPEECH_DEMO=OFF ../../dldt/
