import cv2
import numpy as np
import tensorflow as tf  # 2.0
from typing import List


class TextRecognizer():
    def __init__(self, xml_model_path: str):
        """
            :param xml_model_path: path to model's XML file
        """
        self._net = cv2.dnn.readNetFromModelOptimizer(xml_model_path, xml_model_path[:-3] + 'bin')

    def _get_ocr_pred(self, img: np.ndarray, box: tuple) -> np.ndarray:
        "get OCR prediction from part of image in memory"
        y1, x1, y2, x2 = box
        img = img[y1:y2, x1:x2]
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        blob = cv2.dnn.blobFromImage(img, 1, (120, 32))
        self._net.setInput(blob)
        outs = self._net.forward()
        return outs

    def do_ocr(self, img: np.ndarray, bboxes: List[tuple]) -> List[str]:
        answer = []
        # net could detect only these chars
        char_vec = np.array(list("0123456789abcdefghijklmnopqrstuvwxyz#"))

        for box in bboxes:
            outs = self._get_ocr_pred(img, box)
            # The network output can be decoded by CTC Greedy Decoder or CTC Beam Search decoder.
            # 30 is outs,shape[0] it is fixed
            a, b = tf.nn.ctc_beam_search_decoder(outs, np.array([30]))
            #a, b = tf.nn.ctc_greedy_decoder(outs, np.array([30]), merge_repeated=True)

            ff = tf.sparse.to_dense(a[0])[0].numpy()
            answer.append("".join([char_vec[i] for i in ff]))
        return answer
