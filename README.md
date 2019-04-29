# opencv-python-inference-engine

It is *Unofficial* pre-built OpenCV+dldt_module package for Python.

**Why:**
There is a [guy with an exellent pre-built set of OpenCV packages](https://github.com/skvark/opencv-python), but they are all came without [dldt module](https://github.com/opencv/dldt).

+ Package comes without contrib modules.
+ It was tested on Ubuntu 18.04, Ubuntu 18.10 as Windows 10 Subsystem and Gentoo.
+ I had not made a builds for Windows or MacOS.
+ It is 64 bit.

## Installing from `pip3`

You will need a `glibc-2.27`(thus it will work for Ubuntu >=18.04) and `libtbb2` to run it.

Also it was built with `ffmpeg-4.1.3` support.

Remove previously installed versions of `cv2`

```bash
sudo apt-get install libtbb2
pip3 install opencv-python-inference-engine
```

## Compiling from source

### Requirements

<https://github.com/opencv/dldt/blob/2018/inference-engine/README.md>

<https://docs.opencv.org/4.0.0/d7/d9f/tutorial_linux_install.html>

`libtbb-dev`

It tested and working with [OpenCV-4.1.0](https://github.com/opencv/opencv/releases) with [dldt-2019_R1](https://github.com/opencv/dldt/releases).

### Preparing

Download releases 

Download releases and unpack archives to `dldt` and `opencv` folders.


You'll need to get 3rd party code for dldt:

```bash
cd dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard 562e301
```

Next, we will need a python3 virtual environment with `numpy`:

```bash
virtualenv --clear --always-copy -p /usr/bin/python3 ./venv
./venv/bin/pip3 install numpy
```

### Compilation

`$ABS_PORTION` is a absolute path to `opencv-python-inference-engine` dir.

```bash
export ABS_PORTION=YOUR_ABSOLUTE_PATH_TO_opencv-python-inference-engine_dir

cd build/ffmpeg
bash ./ffmpeg_setup.sh
make -j8

cd build/dldt
# if you do not want to buld all IE tests --
# comment L:142 in `dldt/inference-engine/CMakeLists.txt`
#   add_subdirectory(tests) 
bash ./dldt_setup.sh
make -j8

cd ../opencv
bash ./opencv_setup.sh
make -j8
```

### Wheel creation

```bash
# get all compiled libs together
cp build/opencv/lib/python3/cv2.cpython-36m-x86_64-linux-gnu.so create_wheel/cv2/

cp dldt/inference-engine/bin/intel64/Release/lib/*.so create_wheel/cv2/

# change RPATH
chrpath -r '$ORIGIN' create_wheel/cv2/cv2.cpython-36m-x86_64-linux-gnu.so 

# final .whl will be in /create_wheel/dist/
cd create_wheel
python3 setup.py bdist_wheel
```
