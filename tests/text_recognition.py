import cv2
import numpy as np
from typing import List


class TextRecognizer():
    def __init__(self, xml_model_path: str):
        """ Class for the Intels' OCR model pipeline

            See https://github.com/openvinotoolkit/open_model_zoo/blob/master/models/intel/ \
                text-recognition-0012/description/text-recognition-0012.md

            :param xml_model_path: path to model's XML file
        """
        # load model
        self._net = cv2.dnn.readNetFromModelOptimizer(xml_model_path, xml_model_path[:-3] + 'bin')

    def _get_confidences(self, img: np.ndarray, box: tuple) -> np.ndarray:
        """ get OCR prediction confidences from a part of image in memory

            :param img: BGR image
            :param box: (ymin ,xmin ,ymax, xmax)

            :return: blob with the shape [30, 1, 37] in the format [WxBxL], where:
                    W - output sequence length
                    B - batch size
                    L - confidence distribution across alphanumeric symbols:
                        "0123456789abcdefghijklmnopqrstuvwxyz#", where # - special
                        blank character for CTC decoding algorithm.
        """
        y1, x1, y2, x2 = box
        img = img[y1:y2, x1:x2]
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        blob = cv2.dnn.blobFromImage(img, 1, (120, 32))
        self._net.setInput(blob)
        outs = self._net.forward()
        return outs

    def do_ocr(self, img: np.ndarray, bboxes: List[tuple]) -> List[str]:
        """ Run OCR pipeline for a single words

            :param img: BGR image
            :param bboxes: list of sepaate word bboxes (ymin ,xmin ,ymax, xmax)

            :return: recognized words

            For TF version use:

            .. code-block:: python

                # 30 is `confs.shape[0]` it is fixed
                a, b = tf.nn.ctc_beam_search_decoder(confs, np.array([30]))
                idx_no_blanks = tf.sparse.to_dense(a[0])[0].numpy()
                word = ''.join(char_vec[idxs_no_blanks])
        """
        words = []
        # net could detect only these chars
        char_vec = np.array(list("0123456789abcdefghijklmnopqrstuvwxyz#"))

        for box in bboxes:
            # confidence distribution across symbols
            confs = self._get_confidences(img, box)
            # get maximal confidence for the whole beam width
            idxs = confs[:, 0, :].argmax(axis=1)
            # drop blank characters '#' with id == 36 in charvec
            # isupposedly we taking only separate words as input
            idxs_no_blanks = idxs[idxs != 36]
            # joint to string
            word = ''.join(char_vec[idxs_no_blanks])
            words.append(word)

        return words
