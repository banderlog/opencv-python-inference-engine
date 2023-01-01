[![Downloads](https://pepy.tech/badge/opencv-python-inference-engine)](https://pepy.tech/project/opencv-python-inference-engine) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/month)](https://pepy.tech/project/opencv-python-inference-engine/month) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/week)](https://pepy.tech/project/opencv-python-inference-engine/week)

# opencv-python-inference-engine

This is *Unofficial* pre-built OpenCV with the inference engine part of [OpenVINO](https://github.com/openvinotoolkit/openvino) package for Python.

## Installing from `pip3`

Remove previously installed versions of `cv2`

```bash
pip3 install opencv-python-inference-engine
```

## Examples of usage

Please see the `examples.ipynb` in the `tests` folder.

You will need to preprocess data as a model requires and decode the output. A description of the decoding *should* be in the model documentation with examples in open-vino documentation, however, in some cases, the original article may be the only information source. Some models are very simple to encode/decode, others are tough (e.g., PixelLink in tests).


## Downloading intel models

The official way is awkward because you need to git clone the whole [model_zoo](https://github.com/opencv/open_model_zoo) ([details](https://github.com/opencv/open_model_zoo/issues/522))

Better to find a model description [here](https://github.com/opencv/open_model_zoo/blob/master/models/intel/index.md) and download manually from [here](https://download.01.org/opencv/2021/openvinotoolkit/2021.2/open_model_zoo/models_bin/3/)


## Description


### Why

I needed an ability to fast deploy a small package that able to run models from [Intel's model zoo](https://github.com/openvinotoolkit/open_model_zoo) and use [Movidius NCS](https://software.intel.com/en-us/neural-compute-stick).
Well-known [opencv-python](https://github.com/skvark/opencv-python) can't do this.
The official way is to use OpenVINO, but it is big and clumsy (just try to use it with python venv or fast download it on cloud instance).


### Limitations

+ Package comes without contrib modules.
+ You need to [add udev rules](https://www.intel.com/content/www/us/en/support/articles/000057005/boards-and-kits.html) if you want working MYRIAD plugin.
+ It was tested on Ubuntu 18.04, Ubuntu 18.10 as Windows 10 Subsystem and Gentoo.
+ It will not work for Ubuntu 16.04 and below (except v4.1.0.4).
+ I had not made builds for Windows or MacOS.
+ It built with `ffmpeg` and `v4l` support (`ffmpeg` libs included).
+ No GTK/QT support -- use `matplotlib` for plotting your results.
+ It is 64 bit.

### Main differences from `opencv-python-headless`

+ Usage of `AVX2` instructions
+ No `JPEG 2000`, `WEBP`, `OpenEXR` support
+ `TBB` used as a parallel framework
+ Inference Engine with `MYRIAD` plugin

### Main differences from OpenVINO

+ No model-optimizer
+ No [ITT](https://software.intel.com/en-us/articles/intel-itt-api-open-source)
+ No [IPP](https://software.intel.com/en-us/ipp)
+ No [Intel Media SDK](https://software.intel.com/en-us/media-sdk)
+ No [OpenVINO IE API](https://github.com/opencv/dldt/tree/2020/inference-engine/ie_bridges/python/src/openvino/inference_engine)
+ No python2 support (it is dead)
+ No Gstreamer (use ffmpeg)
+ No GTK (+16 MB and a lot of problems and extra work to compile Qt\GTK libs from sources.)

For additional info read `cv2.getBuildInformation()` output.

### Versioning

`YYYY.MM.DD`, because it is the most simple way to track opencv/openvino versions.

## Compiling from source

You will need ~7GB RAM and ~10GB disk space

I am using Ubuntu 18.04 (python 3.6) [multipass](https://multipass.run/) instance: `multipass launch -c 6 -d 10G -m 8G 18.04`.

### Requirements

From [opencv](https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html), [dldt](https://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html),
 [ffmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu), and [ngraph](https://www.ngraph.ai/documentation/buildlb)

```bash
# We need newer `cmake` for dldt (fastest way I know)
# >=cmake-3.16
sudo apt remove --purge cmake
hash -r
sudo snap install cmake --classic

# nasm for ffmpeg
# libusb-1.0-0-dev for MYRIAD plugin
sudo apt update
sudo apt install build-essential git pkg-config python3-dev nasm python3 virtualenv libusb-1.0-0-dev chrpath shellcheck

# for ngraph
# the `dldt/_deps/ext_onnx-src/onnx/gen_proto.py` has `#!/usr/bin/env python` string and will throw an error otherwise
sudo ln -s  /usr/bin/python3 /usr/bin/python
```

### Preparing

```bash
git clone https://github.com/banderlog/opencv-python-inference-engine
cd opencv-python-inference-engine
# git checkout dev
./download_all_stuff.sh
```

### Compilation

```bash
cd build/ffmpeg
./ffmpeg_setup.sh &&
./ffmpeg_premake.sh &&
make -j6 &&
make install

cd ../dldt
./dldt_setup.sh &&
make -j6

# NB: check `-D INF_ENGINE_RELEASE` value
# should be in form YYYYAABBCC (e.g. 2020.1.0.2 -> 2020010002)")
cd ../opencv
./opencv_setup.sh &&
make -j6
```

### Wheel creation

```bash
# get all compiled libs together
cd ../../
cp build/opencv/lib/python3/cv2.cpython*.so create_wheel/cv2/cv2.so

cp dldt/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/bin/intel64/Release/lib/plugins.xml create_wheel/cv2/
cp dldt/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

cp build/ffmpeg/binaries/lib/*.so create_wheel/cv2/

# change RPATH
cd create_wheel
for i in  cv2/*.so; do chrpath -r '$ORIGIN' $i; done

# final .whl will be in /create_wheel/dist/
# NB: check version in the `setup.py`
../venv/bin/python3 setup.py bdist_wheel
```

### Optional things to play with

+ [dldt build instruction](https://github.com/openvinotoolkit/openvino/wiki/CMakeOptionsForCustomCompilation)
+ [dldt cmake flags](https://github.com/openvinotoolkit/openvino/blob/master/inference-engine/cmake/features.cmake)
+ [opencv cmake flags](https://github.com/opencv/opencv/blob/master/CMakeLists.txt)

**NB:** removing `QUIET` from `find_package()` in project Cmake files, could help to solve some problems -- сmake will start to log them.


#### GTK2

Make next changes in `opencv-python-inference-engine/build/opencv/opencv_setup.sh`:
1. change string `-D WITH_GTK=OFF \`  to `-D WITH_GTK=ON \`
2. `export PKG_CONFIG_PATH=$ABS_PORTION/build/ffmpeg/binaries/lib/pkgconfig:$PKG_CONFIG_PATH` -- you will need to
   add absolute paths to `.pc` files. On Ubuntu 18.04 they here:
   `/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:/usr/local/lib/pkgconfig/:/usr/lib/pkgconfig/`

Exporting `PKG_CONFIG_PATH` for `ffmpeg` somehow messes with default values.

It will add ~16MB to the package.

#### Integrated Performance Primitives

Just set `-D WITH_IPP=ON` in `opencv_setup.sh`.

It will give +30MB to the final `cv2.so` size. And it will boost _some_ opencv functions.

[Official Intel's IPP benchmarks](https://software.intel.com/en-us/ipp/benchmarks) (may ask for registration)

#### MKL

You need to download MKL-DNN release and set two flags:`-D GEMM=MKL` , `-D MKLROOT` ([details](https://github.com/opencv/dldt/issues/327))

OpenVino comes with 30MB `libmkl_tiny_tbb.so`, but [you will not be able to compile it](https://github.com/intel/mkl-dnn/issues/674), because it made from proprietary MKL.

Our opensource MKL-DNN experiment will end with 125MB `libmklml_gnu.so` and inference speed compatible with 5MB openblas ([details](https://github.com/banderlog/opencv-python-inference-engine/issues/5)).


#### CUDA

I did not try it. But it cannot be universal, it will only work with the certain combination of GPU+CUDA+cuDNN for which it will be compiled for.

+ [Compile OpenCV’s ‘dnn’ module with NVIDIA GPU support](https://www.pyimagesearch.com/2020/02/10/opencv-dnn-with-nvidia-gpus-1549-faster-yolo-ssd-and-mask-r-cnn/)
+ [Use OpenCV’s ‘dnn’ module with NVIDIA GPUs, CUDA, and cuDNN](https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/)


#### OpenMP

It is possible to compile OpenBLAS, dldt and OpenCV with OpenMP. I am not sure that the result would be better than now, but who knows.
