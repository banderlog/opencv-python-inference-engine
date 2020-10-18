import cv2
import numpy as np
from IPython import get_ipython

# prepare all stuff and do the first inference
# it will load all things into memory
xml_model_path = "se_net.xml"
net = cv2.dnn.readNet(xml_model_path, xml_model_path[:-3] + 'bin')
# generate image and put it into the NN
blob = (np.random.standard_normal((1, 3, 224, 224)) * 255).astype(np.uint8)
net.setInput(blob)
# select target & backend, please read the documentation for details:
# <https://docs.opencv.org/4.5.0/db/d30/classcv_1_1dnn_1_1Net.html#a9dddbefbc7f3defbe3eeb5dc3d3483f4>
net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)
_ = net.forward()

# measure the inference speed
get_ipython().magic("timeit _ = net.forward()")
