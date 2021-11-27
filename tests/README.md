# Tests for opencv-python-inference-engine wheel

## Requirements

`sudo apt install virtualenv`

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

**NB:** be strict about Backend and Target

```python
import cv2

class PixelLinkDetectorTest():
    """ Cut version of PixelLinkDetector """
    def __init__(self, xml_model_path: str):
        self.net = cv2.dnn.readNet(xml_model_path, xml_model_path[:-3] + 'bin')

    def detect(self, img: 'np.ndarray') -> None:
        blob = cv2.dnn.blobFromImage(img, 1, (1280, 768))
        self.net.setInput(blob)
        out_layer_names = self.net.getUnconnectedOutLayersNames()
        return self.net.forward(out_layer_names)


# check opencv version
cv2.__version__

# read img and network
img = cv2.imread('helloworld.png')
detector = PixelLinkDetectorTest('text-detection-0004.xml')

# select target & backend, please read the documentation for details:
# <https://docs.opencv.org/4.2.0/db/d30/classcv_1_1dnn_1_1Net.html#a9dddbefbc7f3defbe3eeb5dc3d3483f4>
detector.net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
detector.net.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)

# 1st inference does not count
links, pixels = detector.detect(img)

# use magic function
%timeit links, pixels = detector.detect(img)
```


## Models

+ [rateme](https://github.com/banderlog/rateme) (YOLO3)
+ [text-detection-0004](https://github.com/opencv/open_model_zoo/blob/master/models/intel/text-detection-0004/description/text-detection-0004.md)
+ [text-recognition-0012](https://github.com/opencv/open_model_zoo/blob/master/models/intel/text-recognition-0012/description/text-recognition-0012.md)

## Files

+ `short_video.mp4` from [here](https://www.pexels.com/video/a-cattails-fluff-floats-in-air-2156021/)  (free)
+ `dislike.jpg` from [rateme repository](https://github.com/banderlog/rateme/blob/master/test_imgs/dislike.jpg)
+ `helloworld.png` I either made it or forgot from where it downloaded from
