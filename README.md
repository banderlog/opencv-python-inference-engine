[![Downloads](https://pepy.tech/badge/opencv-python-inference-engine)](https://pepy.tech/project/opencv-python-inference-engine) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/month)](https://pepy.tech/project/opencv-python-inference-engine/month) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/week)](https://pepy.tech/project/opencv-python-inference-engine/week)

# opencv-python-inference-engine

It is *Unofficial* pre-built OpenCV+dldt_module package for Python.

**Why:**  
There is a [guy with an exellent pre-built set of OpenCV packages](https://github.com/skvark/opencv-python), but they are all came without [dldt module](https://github.com/opencv/dldt). And you need that module if you want to run models from [Intel's model zoo](https://github.com/opencv/open_model_zoo/).

**UPD:** Presumably, you could also use speech2text model now -- [source](https://docs.openvinotoolkit.org/latest/_inference_engine_samples_speech_libs_and_demos_Speech_libs_and_demos.html)

**Limitations**:
+ Package comes without contrib modules.
+ You need to [add udev rules](https://github.com/opencv/dldt/blob/2019/inference-engine/README.md#for-linux-raspbian-stretch-os) if you want working MYRIAD plugin.
+ It was tested on Ubuntu 18.04, Ubuntu 18.10 as Windows 10 Subsystem and Gentoo.
+ It will not work for Ubuntu 16.04 and below (except v4.1.0.4).
+ I had not made builds for Windows or MacOS.
+ It is 64 bit.
+ It built with `ffmpeg` and `v4l` support (`ffmpeg` libs included).
+ No GTK/QT support -- use `matplotlib` for plotting your results.

This package is most similar to `opencv-python-headless`, main differences are:
+ Usage of `AVX2` instructions
+ No `JPEG 2000`, `WEBP`, `OpenEXR` support
+ `TBB` used as a parallel framework
+ Inference Engine with `MYRIAD` plugin

For additional info read `cv2.getBuildInformation()` output.

## Installing from `pip3`

Remove previously installed versions of `cv2`

```bash
pip3 install opencv-python-inference-engine
```

## Downloading intel models

As it appeared it is not an obvious task :)

Please refer to: https://github.com/opencv/open_model_zoo/issues/522

## Known problems and TODOs

### No Ubuntu 16.04 support

Release [v4.1.0.4](https://github.com/banderlog/opencv-python-inference-engine/releases/tag/v4.1.0.4) is working with Ubuntu 16.04 ([#3](https://github.com/banderlog/opencv-python-inference-engine/issues/3)).

All releases before it were compiled on Ubuntu 18.04 and it has different versions of `glibc`, `cmake`, etc.
So make it Ubuntu 16.04 compatible was pretty easy -- just change one standard build environment to another.

But `dldt-2019R2` requires `cmake-3.7.2`, which is absent in Ubuntu 16.04. And, of course, it can be installed, but works-from-the-box behavior is loosed 
from now on.

### No GTK/QT support

[skvarks's package](https://github.com/skvark/opencv-python) has `Qt4` GUI for `opencv` and it is +16 MB to file size.
Also it is a lot of problems and extra work to compile Qt\GTK libs from sources.
In 95% of cases `matplotlib.imshow()` will be sufficient, in other 5% use another package for now or compile it with GUI
support by yourself.

#### Steps to compile it with `GTK-2` support (checked)

Make next changes in `opencv-python-inference-engine/build/opencv/opencv_setup.sh`:
1. change string `-D WITH_GTK=OFF \`  to `-D WITH_GTK=ON \`
2. change `export PKG_CONFIG_PATH=$ABS_PORTION/build/ffmpeg/binaries/lib/pkgconfig:$PKG_CONFIG_PATH` -- you will need to
   add absolute paths to `.pc` files. On Ubuntu 18.04 it were
   `/usr/lib/x86_64-linux-gnu/pkgconfig/:/usr/share/pkgconfig/:/usr/local/lib/pkgconfig/:/usr/lib/pkgconfig/`

Exporting `PKG_CONFIG_PATH` for `ffmpeg` somehow messes with default values.

### Not really `manylinux1`

The package is renamed to `manylinux1` from `linux`, because, according to [PEP 513](https://www.python.org/dev/peps/pep-0513/), PyPi repo does not want to apply other architectures.
And compiling it for CentOS 5.11 is pretty challenging (there is no such lxd container plus I do not want to mess with docker) and denies from using some of the necessary libs (like tbb).
Also, I suspect that it will be poorly optimized.

### Build `ffmpeg` with `tbb`

Both `dldt` and `opencv` are compiled with `tbb` support, and `ffmpeg` compiled without it -- this does not feels right.
There is some unproved solution for how to compile `ffmpeg` with `tbb` support:
+ <https://stackoverflow.com/questions/6049798/ffmpeg-mt-and-tbb>  
+ <https://stackoverflow.com/questions/14082360/pthread-vs-intel-tbb-and-their-relation-to-openmp>

Maybe someday I will try it.

### Versioning

First 3 letters are the version of OpenCV, the last one -- package version. E.g, `4.1.0.2` -- 2nd version of based on 4.1.0 OpenCV package. Package versions are not continuously numbered -- each new OpenCV version starts its own numbering.


## Compiling from source

I compiled it on Ubuntu 18.04 Linux Container.

### Requirements

+ <https://github.com/opencv/dldt/blob/2018/inference-engine/README.md> 
+ <https://docs.opencv.org/4.0.0/d7/d9f/tutorial_linux_install.html> (`build-essential`, `cmake`, `git`, `pkg-config`, `python3-dev`)
+ `nasm` (for ffmpeg)
+ `python3`
+ `virtualenv`
+ `libusb-1.0-0-dev` (for dldt  >= 2019_R1.0.1)
+ `chrpath`
+ `patchelf`

```
sudo apt-get update
sudo apt install build-essential cmake git pkg-config python3-dev nasm python3 virtualenv libusb-1.0-0-dev chrpath patchelf
```

### Preparing

0. `git clone https://github.com/banderlog/opencv-python-inference-engine`
1. `cd opencv-python-inference-engine`
2. run `download_all_stuff.sh` (refer for script code for details)

### Compilation

`$ABS_PORTION` is a absolute path to `opencv-python-inference-engine` dir.

```bash

cd build/ffmpeg
./ffmpeg_setup.sh
./ffmpeg_premake.sh
make -j8
make install


cd ../dldt
./dldt_setup.sh
make -j8


cd ../opencv
ABS_PORTION=YOUR_ABSOLUTE_PATH_TO_opencv-python-inference-engine_dir ./opencv_setup.sh
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

cp mklml_lnx/lib/libmklml_gnu.so create/wheel/cv2


cd create_wheel
# change RPATH
for i in  cv2/*.so; do chrpath -r '$ORIGIN' $i; done

# final .whl will be in /create_wheel/dist/
../venv/bin/python3 setup.py bdist_wheel
```
