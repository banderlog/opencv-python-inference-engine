[![Downloads](https://pepy.tech/badge/opencv-python-inference-engine)](https://pepy.tech/project/opencv-python-inference-engine) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/month)](https://pepy.tech/project/opencv-python-inference-engine/month) [![Downloads](https://pepy.tech/badge/opencv-python-inference-engine/week)](https://pepy.tech/project/opencv-python-inference-engine/week)

# opencv-python-inference-engine

It is *Unofficial* pre-built OpenCV+dldt_module package for Python.

**Why:**  
There is a [guy with an exellent pre-built set of OpenCV packages](https://github.com/skvark/opencv-python), but they are all came without [dldt module](https://github.com/opencv/dldt). And you need that module if you want to run models from [Intel's model zoo](https://github.com/opencv/open_model_zoo/).

**Limitations**:
+ Package comes without contrib modules.
+ It was tested on Ubuntu 16.04, Ubuntu 18.04, Ubuntu 18.10 as Windows 10 Subsystem and Gentoo.
+ I had not made builds for Windows or MacOS.
+ It is 64 bit.
+ It built with `ffmpeg` and `v4l` support (`ffmpeg` libs included).
+ No GTK/QT support -- use `matplotlib` for plotting your results.

This package is most similar to `opencv-python-headless`, main differences are:
+ Usage of `AVX512_SKX` instructions
+ No `JPEG 2000`, `WEBP`, `OpenEXR` support
+ `TBB` used as a parallel framework
+ Inference Engine with `MYRIAD` plugin

For additional info read `cv2.getBuildInformation()` output.

## Installing from `pip3`

Remove previously installed versions of `cv2`

```bash
pip3 install opencv-python-inference-engine
```

## Known problems and TODOs

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
<https://stackoverflow.com/questions/6049798/ffmpeg-mt-and-tbb>  
<https://stackoverflow.com/questions/14082360/pthread-vs-intel-tbb-and-their-relation-to-openmp>

Maybe someday I will try it.

### Versioning

First 3 letters are the version of OpenCV, the last one -- package version. E.g, `4.1.0.2` -- 2nd version of based on 4.1.0 OpenCV package. Package versions are not continuously numbered -- each new OpenCV version starts its own numbering.


## Compiling from source

I compiled it on Ubuntu 16.04 Linux Container.

### Requirements

+ <https://github.com/opencv/dldt/blob/2018/inference-engine/README.md> 
+ <https://docs.opencv.org/4.0.0/d7/d9f/tutorial_linux_install.html> (`build-essential`, `cmake`, `git`, `pkg-config`, `python3-dev`)
+ `nasm` (for ffmpeg)
+ `python3`
+ `virtualenv`
+ `libusb-1.0-0-dev` (for dldt  >= 2019_R1.0.1)
+ `chrpath`

```
sudo apt-get update
sudo apt install build-essential cmake git pkg-config python3-dev nasm python3 virtualenv libusb-1.0-0-dev chrpath
```

Last successfully tested with dldt-2019_R1.1, opencv-4.1.0, ffmpeg-4.1.3

### Preparing

1. Download releases of [dldt](https://github.com/opencv/dldt/releases), [opencv](https://github.com/opencv/opencv/releases) and [ffmpeg](https://github.com/FFmpeg/FFmpeg/releases) (or clone their repos)
2. Unpack archives to `dldt`,`opencv` and `ffmpeg` folders.

3. You'll need to get 3rd party `ade` code for dldt of certain commit (as in original dldt repo):

```bash
cd dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard 562e301
```

4. Next, we will need a python3 virtual environment with `numpy`:

```bash
# return to "opencv-python-inference-engine" dir
cd ../../../../
virtualenv --clear --always-copy -p /usr/bin/python3 ./venv
./venv/bin/pip3 install numpy
```

### Compilation

`$ABS_PORTION` is a absolute path to `opencv-python-inference-engine` dir.

```bash

cd build/ffmpeg
./ffmpeg_setup.sh
./ffmpeg_premake.sh
make -j8
make install

cd ../dldt
# if you do not want to buld all IE tests --
# comment L:142 in `../../dldt/inference-engine/CMakeLists.txt` ("add_subdirectory(tests)")
# <https://github.com/opencv/dldt/pull/139>
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

cp dldt/inference-engine/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/inference-engine/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/inference-engine/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

cp build/ffmpeg/binaries/lib/*.so create_wheel/cv2/

# change RPATH
chrpath -r '$ORIGIN' create_wheel/cv2/cv2.so 

# final .whl will be in /create_wheel/dist/
cd create_wheel
../venv/bin/python3 setup.py bdist_wheel
```
