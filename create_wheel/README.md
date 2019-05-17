# README

This is a pre-built [OpenCV](https://github.com/opencv/opencv) with [dldt](https://github.com/opencv/dldt) module package for Python3.

Contrib modules and haarcascades are not included.

It built with `ffmpeg` and `v4l` support.

It compiled with `TBB` lib selected as threading lib, so you will need to
install it (`libtbb-dev` on Ubuntu).

You will need GTK2 for highgui module (`cv2.imshow()`) 

For additional info read <https://github.com/banderlog/opencv-python-inference-engine/blob/master/README.md> and `cv2.getBuildInformation()` output

**Why:**

There is a [guy with an exellent pre-built set of OpenCV packages](https://github.com/skvark/opencv-python), but they are all came without [dldt module](https://github.com/opencv/dldt).
