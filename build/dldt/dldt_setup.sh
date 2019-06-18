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
#    -D DEVELOPMENT_PLUGIN_MODE=ON \
#    -D PYTHON_EXECUTABLE=$ABS_PORTION/venv/bin/python3.6 \
#    -D PYTHON_LIBRARY=$ABS_PORTION/venv/lib/python3.6/config-3.6m-x86_64-linux-gnu/libpython3.6m.so \
#    -D PYTHON_INCLUDE_DIR=$ABS_PORTION/venv/include/python3.6m/ \
#    -D ENABLE_SAMPLES_CORE = ON \
#    -D MKLDNN_LIBRARY_TYPE=STATIC \
#    -D MKLDNN_THREADING=TBB \
#    -D WITH_EXAMPLE=OFF \
#    -D WITH_TEST=OFF \
#    -D DISABLE_IE_TESTS=ON \
cmake -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=./binaries/ \
    -D THREADING=TBB \
    -D GEMM=JIT \
    -D ENABLE_OPENCV=ON \
    -D OpenCV_DIR=../../opencv \
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
    -D ENABLE_VPU=ON \
    -D ENABLE_MYRIAD=ON \
    -D ENABLE_CLDNN=OFF ../../dldt/inference-engine/
