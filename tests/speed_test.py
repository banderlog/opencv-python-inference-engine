import cv2
import numpy as np
from IPython import get_ipython

# prepare al stuff and do first inference
xml_model_path = "se_net.xml"
net = cv2.dnn.readNet(xml_model_path, xml_model_path[:-3] + 'bin')
blob = (np.random.standard_normal((1, 3, 224, 224)) * 255).astype(np.uint8)
net.setInput(blob)
net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)
_ = net.forward()

# measure the inference speed
get_ipython().magic("timeit _ = net.forward()")

