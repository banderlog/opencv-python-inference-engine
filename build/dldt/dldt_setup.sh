# GEMM (General matrix-matrix multiplication) kernel that computes a
# scalar-matrix-matrix product and adds the result to a scalar-matrix product
# GEMM should be set to MKL, OPENBLAS or JIT. Default option is JIT
#
# The GNA plugin was developed for low power scoring of neural networks on the
# Intel® Speech Enabling Developer Kit, the Amazon Alexa* Premium Far-Field
# Developer Kit, Intel® Pentium® Silver processor J5005, Intel® Celeron®
# processor J4005, Intel® Core™ i3-8121U processor, and others.
#
# The Instrumentation and Tracing Technology (ITT) API enables your application
# to generate and control the collection of trace data during its executio
#
# MKL-DNN -- plugin for CPU
# CLDNN -- plugin for GPU
#
#  For MYRIAD PLUGING:
#    -D ENABLE_VPU=ON \
#    -D ENABLE_MYRIAD=ON \
#
# FOR CROSSCOMPILATION
# `-D OpenCV_DIR=../../opencv`  is wrong
#       NB: OpenCV_DIR is an environmental variable, not cmake's.
#       And it should point to "The directory containing a CMake configuration file for OpenCV"
#       something like `OpenCV_DIR=${CUSTOM_OPENCV_INSTALLATION_PATH}/lib/cmake/opencv4/ ./dldt_setup.sh`
#       but to use it, you have to build OpenCV first.
#       Thus it will be necessary to build opencv without dldtd, that build dldt than build opencv with dldtd
#       That's too complicated and unneeded. Better auto-download binary libs for your system as it was before.
#
# -D BUILD_SHARED_LIBS=ON \ always crash

cmake -D CMAKE_BUILD_TYPE=Release \
    -D THREADING=TBB \
    -D GEMM=JIT \
    -D ENABLE_OPENCV=ON \
    -D ENABLE_MKL_DNN=ON \
    -D BUILD_SHARED_LIBS=OFF \
    -D BUILD_TESTS=OFF \
    -D ENABLE_PLUGIN_RPATH=OFF \
    -D ENABLE_PYTHON=OFF \
    -D ENABLE_TESTS=OFF \
    -D ENABLE_SAMPLES=OFF \
    -D ENABLE_STRESS_UNIT_TESTS=OFF \
    -D ENABLE_GAPI_TESTS=OFF \
    -D GAPI_TEST_PERF=OFF \
    -D ENABLE_SEGMENTATION_TESTS=OFF \
    -D ENABLE_OBJECT_DETECTION_TESTS=OFF \
    -D ENABLE_GNA=OFF \
    -D ENABLE_PROFILING_ITT=OFF \
    -D ENABLE_ALTERNATIVE_TEMP=OFF \
    -D ENABLE_CLDNN=OFF ../../dldt/inference-engine/
