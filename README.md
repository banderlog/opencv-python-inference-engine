[![Downloads](https://pepy.tech/badge/opencv-python-inference-engine)](https://pepy.tech/project/opencv-python-inference-engine) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/month)](https://pepy.tech/project/opencv-python-inference-engine/month) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/week)](https://pepy.tech/project/opencv-python-inference-engine/week)

# opencv-python-inference-engine

This is *Unofficial* pre-built OpenCV with inference engine module Python wheel.

## Installing from `pip3`

Remove previously installed versions of `cv2`

```bash
pip3 install opencv-python-inference-engine
```


## Why  

I needed an ability to fast deploy a small package that able to run models from [Intel's model zoo](https://github.com/opencv/open_model_zoo/) and use [Movidius NCS](https://software.intel.com/en-us/neural-compute-stick). Well known [opencv-python](https://github.com/skvark/opencv-python) can't do this. The official way is to use OpenVINO, but it is big and clumsy (just try to use it with python venv or fast download it on cloud instance).


## Description

### Limitations

+ Package comes without contrib modules.
+ You need to [add udev rules](https://github.com/opencv/dldt/blob/2019/inference-engine/README.md#for-linux-raspbian-stretch-os) if you want working MYRIAD plugin.
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
+ OPENBLAS instead of MKL (https://github.com/banderlog/opencv-python-inference-engine/issues)
+ No [ITT](https://software.intel.com/en-us/articles/intel-itt-api-open-source)
+ No [IPP](https://software.intel.com/en-us/ipp)
+ No [Intel Media SDK](https://software.intel.com/en-us/media-sdk)
+ No [OpenVINO IE API](https://github.com/opencv/dldt/tree/2020/inference-engine/ie_bridges/python/src/openvino/inference_engine)
+ No python2 support (it is dead)
+ No Gstreamer (use ffmpeg)
+ No GTK (+16 MB and a lot of problems and extra work to compile Qt\GTK libs from sources.)

For additional info read `cv2.getBuildInformation()` output.

### Versioning

First 3 letters are the version of OpenCV, the last one -- package version. E.g, `4.1.0.2` -- 2nd version of based on 4.1.0 OpenCV package. Package versions are not continuously numbered -- each new OpenCV version starts its own numbering.


## Downloading intel models

Official way is clamsy because you need to git clone the whole https://github.com/opencv/open_model_zoo (https://github.com/opencv/open_model_zoo/issues/522)

Better to find model description [here](https://github.com/opencv/open_model_zoo/blob/master/models/intel/index.md) and download manually from [here](https://download.01.org/opencv/2020/openvinotoolkit/2020.1/open_model_zoo/models_bin/1/)


## Compiling from source

You will need ~6GB RAM and ~10GB disk space

I am using Ubuntu 18.04 [multipass](https://multipass.run/) instance: `multipass launch -c 6 -d 10G -m 7G`.

### Requirements

+ `build-essential`
+ `cmake`
+ `git`
+ `pkg-config`
+ `python3-dev`
+ `virtualenv`
+ `chrpath`
+ `libusb-1.0-0-dev` (for MYRIAD plugin)
+ `nasm` (for ffmpeg)

```
sudo apt-get update
sudo apt install build-essential cmake git pkg-config python3-dev nasm python3 virtualenv libusb-1.0-0-dev chrpath
```
### Preparing

1. `git clone https://github.com/banderlog/opencv-python-inference-engine`
2. `cd opencv-python-inference-engine`
3. run `download_all_stuff.sh` (refer for script code for details)

### Compilation

```bash
cd build/openblas
./openblas_setup.sh &&
make -j8 &&
make install

cd ../ffmpeg
./ffmpeg_setup.sh &&
./ffmpeg_premake.sh &&
make -j8 &&
make install

cd ../dldt
./dldt_setup.sh &&
make -j8

cd ../opencv
./opencv_setup.sh &&
make -j8
```

### Wheel creation

```bash
# get all compiled libs together
cd ../../
cp build/opencv/lib/python3/cv2.cpython*.so create_wheel/cv2/cv2.so

cp dldt/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/bin/intel64/Release/lib/plugins.xml create_wheel/cv2/
cp dldt/inference-engine/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

cp build/ffmpeg/binaries/lib/*.so create_wheel/cv2/

cp build/openblas/lib/libopenblas.so.0 create_wheel/cv2/

# change RPATH
cd create_wheel
for i in  cv2/*.so; do chrpath -r '$ORIGIN' $i; done

# final .whl will be in /create_wheel/dist/
../venv/bin/python3 setup.py bdist_wheel
```

### Optional things to play with

+ [dldt build instruction](https://github.com/opencv/dldt/blob/2020/build-instruction.md)
+ [dldt cmake flags](https://github.com/opencv/dldt/blob/b2140c083a068a63591e8c2e9b5f6b240790519d/inference-engine/cmake/features_ie.cmake)
+ [opencv cmake flags](https://github.com/opencv/opencv/blob/master/CMakeLists.txt)

**NB:** removing `QUIET` from `find_package()` in project Cmake files, could help to solve some problems -- сmake will start to log them.


#### GTK2

Make next changes in `opencv-python-inference-engine/build/opencv/opencv_setup.sh`:
1. change string `-D WITH_GTK=OFF \`  to `-D WITH_GTK=ON \`
2. `export PKG_CONFIG_PATH=$ABS_PORTION/build/ffmpeg/binaries/lib/pkgconfig:$PKG_CONFIG_PATH` -- you will need to
   add absolute paths to `.pc` files. On Ubuntu 18.04 they here:
   `/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:/usr/local/lib/pkgconfig/:/usr/lib/pkgconfig/`

Exporting `PKG_CONFIG_PATH` for `ffmpeg` somehow messes with default values.

#### IPP

Just set `-D WITH_IPP=ON` in `opencv_setup.sh`.

It will give +30MB to final `cv2.so` size. And it will boost _some_ opencv functions.

![](https://www.oreilly.com/library/view/learning-opencv-3/9781491937983/assets/lcv3_0105.png)
(Image from [Learning OpenCV 3 by Gary Bradski, Adrian Kaehler](https://www.oreilly.com/library/view/learning-opencv-3/9781491937983/ch01.html))

[Official Intel's IPP benchmarks](https://software.intel.com/en-us/ipp/benchmarks) (may ask for registration)

#### MKL

You need to download MKL-DNN release and set two flags:`-D GEMM=MKL` , `-D MKLROOT` ([details](https://github.com/opencv/dldt/issues/327))

OpenVino comes with 30MB `libmkl_tiny_tbb.so`, but [you will not be able to compile it](https://github.com/intel/mkl-dnn/issues/674), because it made from proprietary MKL.

Our opensource MKL-DNN experiment will end with 125MB `libmklml_gnu.so` and inference speed compatible to 35MB openblas ([details](https://github.com/banderlog/opencv-python-inference-engine/issues/5)).

#### OpenBLAS

1. Download and compile OpenBLAS (as above)
2. Set `D BLAS_LIBRARIES`, `-D BLAS_INCLUDE_DIRS`, `-D GEMM=OPENBLAS` (see `dldt_setup.sh` for details).

+ [OpenBLAS Installation guide](https://github.com/xianyi/OpenBLAS/wiki/Installation-Guide)
+ [OpenBLAS User Manual](https://github.com/xianyi/OpenBLAS/wiki/User-Manual)

If you compile it with `make FC=gfortran`, you'll need to put `libgfortran.so.4` and `libquadmath.so.0` to wheel and set them rpath via `patchelf --set-rpath \$ORIGIN *.so`

https://github.com/opencv/dldt/issues/428

#### CUDA

I did not try it.

+ [Compile OpenCV’s ‘dnn’ module with NVIDIA GPU support](https://www.pyimagesearch.com/2020/02/10/opencv-dnn-with-nvidia-gpus-1549-faster-yolo-ssd-and-mask-r-cnn/)
+ [Use OpenCV’s ‘dnn’ module with NVIDIA GPUs, CUDA, and cuDNN](https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/)


#### Build `ffmpeg` with `tbb`

Both `dldt` and `opencv` are compiled with `tbb` support, and `ffmpeg` compiled without it -- this does not feels right.
There is some unproved solution for how to compile `ffmpeg` with `tbb` support: <https://stackoverflow.com/questions/6049798/ffmpeg-mt-and-tbb>  


#### Use opencv for NLP

Presumably, you could also use speech2text model now -- [source](https://docs.openvinotoolkit.org/latest/_inference_engine_samples_speech_libs_and_demos_Speech_libs_and_demos.html)
