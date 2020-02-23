import cv2
import numpy as np
from pkg_resources import resource_filename
from typing import Optional, Tuple, List, Dict


class CAM:
    """ Create video capture object with smallest buffer possible
    """
    def __init__(self, camid: int):
        self.video = cv2.VideoCapture(camid)
        self.video.set(cv2.CAP_PROP_BUFFERSIZE, 1)

    def next(self) -> 'np.array':
        """ Return new frame each time
        """
        # drop one ine buffer
        self.video.grab()
        self.video.grab()
        success, frame = self.video.retrieve()
        return frame


class YOLO3:
    """ Class for YOLO3 architecture inference and decode using OpenCV
    """
    def __init__(self, cfg_path: str, weights_path: str,
                 classes: Dict[int, str], movidius=False):
        # load net
        self.net = cv2.dnn.readNetFromDarknet(cfg_path, weights_path)
        # use MYRIAD plugin
        if movidius:
            self.net.setPreferableTarget(cv2.dnn.DNN_TARGET_MYRIAD)
        # get proper output layers
        ln = self.net.getLayerNames()
        self.ln = [ln[i[0] - 1] for i in self.net.getUnconnectedOutLayers()]
        # define classes
        self.classes = classes

    def _infere(self, img: np.ndarray) -> Tuple[np.ndarray, int, int]:
        """ Preprocess and infere input image
        """
        # preprocess input image
        blob = cv2.dnn.blobFromImage(img, 1 / 255.0, (416, 416),
                                     swapRB=True, crop=False)
        self.net.setInput(blob)
        # infere
        layerOutputs = self.net.forward(self.ln)
        (H, W) = img.shape[:2]
        return layerOutputs, H, W


class RateMe(YOLO3):
    """ YOLO3 class with predefined cfg, weights and classes
        trained for like/dislike detection
    """
    def __init__(self):
        cfg_path = resource_filename(__name__, "rateme.cfg")
        weights_path = resource_filename(__name__, "rateme.weights")
        YOLO3.__init__(self, cfg_path, weights_path, {0: 'like', 1: 'dislike'})

    def predict(self, img: 'np.array') -> Optional[str]:
        """ Decode inference results
        """
        boxes = []
        confidences = []
        classIDs: List[int] = []
        layerOutputs, H, W = self._infere(img)

        for output in layerOutputs:
            for detection in output:
                scores = detection[5:]
                classID = np.argmax(scores)
                confidence = scores[classID]
                # (centerX, centerY, width, height)
                box = detection[0:4] * np.array([W, H, W, H])
                boxes.append(box)
                confidences.append(float(confidence))
                classIDs.append(classID)
        # non maximum suppression
        idxs = cv2.dnn.NMSBoxes(boxes, confidences, 0.8, 0.3)
        if len(idxs) == 0:
            return None
        # return only first one
        #boxes = np.take(np.array(boxes), idxs.flatten(), axis=0)
        #confidences = np.take(np.array(confidences), idxs.flatten(), axis=0)
        classIDs = np.take(np.array(classIDs), idxs.flatten(), axis=0)
        return self.classes[classIDs[0]]
