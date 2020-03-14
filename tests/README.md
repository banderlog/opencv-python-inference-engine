# Tests for opencv-python-inference-engine wheel

## Usage

### Features

Just run bash script and read output.

```bash
cd tests
./prepare_and_run_tests.sh
```

### Inference speed

Something like below. The general idea is to test only inference speed, without preprocessing and decoding.
Also, 1st inference must not count, because it will load all stuff into memory.
I prefer to do such things in `ipython` or `jupyter` with `%timeit`.

**NB:** be strict about Backend and Target

```python
import cv2
from pixellink import PixelLinkDetector

# read img and network
img = cv2.imread('helloworld.png')
detector = PixelLinkDetector('text-detection-0004.xml')

# select target & backend, please read the documentation for details:
# <https://docs.opencv.org/4.2.0/db/d30/classcv_1_1dnn_1_1Net.html#a9dddbefbc7f3defbe3eeb5dc3d3483f4>
detector._net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
detector._net.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)

# 1st inference does not count
detector.detect(img)

# use magic function
%timeit detector.detect(img)
```


## Models

+ [rateme](https://github.com/heyml/rateme) (YOLO3).
+ [text-detection-0004](https://github.com/opencv/open_model_zoo/blob/master/models/intel/text-detection-0004/description/text-detection-0004.md)
+ [text-recognition-0012](https://github.com/opencv/open_model_zoo/blob/master/models/intel/text-recognition-0012/description/text-recognition-0012.md)

## Files

+ `short_video.mp4` from [here](https://www.pexels.com/video/a-cattails-fluff-floats-in-air-2156021/)  (free)
+ `dislike.jpg` from [rateme repository](https://github.com/heyml/rateme/tree/master/test_imgs).
+ `helloworld.png` I either made it or forgot from where it downloaded from
