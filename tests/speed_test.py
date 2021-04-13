import cv2
import numpy as np
import time

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
RUNS = 10
times = []
for _ in range(RUNS):
    start_time = time.time()
    _ = net.forward()
    times.append((time.time() - start_time) * 1000)
print(f'Mean inference time {np.mean(times):.3f} ± {np.std(times):.3f} ms ({RUNS} runs)')
