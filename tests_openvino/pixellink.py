""" Wrapper class for Intel's PixelLink realisation (text segmentation NN)
    text-detection-00[34]

    For text-detection-002 you'll need to uncomment string in detect()
"""
import cv2
import numpy as np
from openvino.runtime import Core
from skimage.morphology import label
from skimage.measure import regionprops
from typing import List, Tuple
from skimage.measure._regionprops import RegionProperties


class PixelLinkDetector():
    """ Wrapper class for Intel's version of PixelLink text detector

        See https://github.com/openvinotoolkit/open_model_zoo/blob/master/models/intel/ \
            text-detection-0004/description/text-detection-0004.md

        :param xml_model_path: path to XML file

        **Example:**

        .. code-block:: python
            detector = PixelLinkDetector('text-detection-0004.xml')
            img = cv2.imread('tmp.jpg')
            # ~250ms on i7-6700K
            detector.detect(img)
            # ~2ms
            bboxes = detector.decode()
    """
    def __init__(self, xml_model_path: str, txt_threshold=0.5):
        """
            :param xml_model_path: path to model's XML file
            :param txt_threshold: confidence, defaults to ``0.5``
        """
        ie = Core()
        model = ie.read_model(xml_model_path)
        self._net = ie.compile_model(model=model, device_name="CPU")
        #self._net = cv2.dnn.readNet(xml_model_path, xml_model_path[:-3] + 'bin')
        self._txt_threshold = txt_threshold

    def detect(self, img: np.ndarray) -> None:
        """ GetPixelLink's outputs (BxCxHxW):
                + [1x16x192x320] - logits related to linkage between pixels and their neighbors
                + [1x2x192x320] - logits related to text/no-text classification for each pixel

            B - batch size
            C - number of channels
            H - image height
            W - image width

            :param img: image as ``numpy.ndarray``
        """
        #input_layer = self._net.input(0)
        output_layer_1 = self._net.output(0)
        output_layer_2 = self._net.output(1)
        self._img_shape = img.shape
        blob = cv2.dnn.blobFromImage(img, 1, (1280, 768))
        #self._net.setInput(blob)
        #out_layer_names = self._net.getUnconnectedOutLayersNames()
        # for text-detection-002
        # self.pixels, self.links = self._net.forward(out_layer_names)
        # for text-detection-00[34]
        #self.links, self.pixels = self._net.forward(out_layer_names)
        #self.links, self.pixels = self._net([blob])[output_layer]
        #self.links = self._net([blob])[output_layer_1]
        #self.pixels = self._net([blob])[output_layer_2]
        out = self._net([blob])
        self.links = out[output_layer_1]
        self.pixels = out[output_layer_2]

    def get_mask(self) -> np.ndarray:
        """ Get binary mask of detected text pixels
        """
        pixel_mask = self._get_pixel_scores() >= self._txt_threshold
        return pixel_mask.astype(np.uint8)

    def _logsumexp(self, a: np.ndarray, axis=-1) -> np.ndarray:
        """ Castrated function from scipy
            https://github.com/scipy/scipy/blob/v1.6.2/scipy/special/_logsumexp.py

            Compute the log of the sum of exponentials of input elements.
        """
        a_max = np.amax(a, axis=axis, keepdims=True)
        tmp = np.exp(a - a_max)
        s = np.sum(tmp, axis=axis, keepdims=True)
        out = np.log(s)
        out += a_max
        return out

    def _get_pixel_scores(self) -> np.ndarray:
        """ get softmaxed properly shaped pixel scores """
        # move channels to the end
        tmp = np.transpose(self.pixels, (0, 2, 3, 1))
        # softmax from scipy
        tmp = np.exp(tmp - self._logsumexp(tmp, axis=-1))
        # select single batch, single chanel values
        return tmp[0, :, :, 1]

    def _get_txt_regions(self, pixel_mask: np.ndarray) -> List[RegionProperties]:
        """ kernels are class dependent """
        img_h, img_w = self._img_shape[:2]
        _, mask = cv2.threshold(pixel_mask, 0, 1, cv2.THRESH_BINARY)
        # transmutatioins
        # kernel size should be image size dependant (default (21,21))
        # on small image it will connect separate words
        txt_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
        mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, txt_kernel)
        # connect regions on mask of original img size
        mask = cv2.resize(mask, (img_w, img_h), interpolation=cv2.INTER_NEAREST)
        # Label connected regions of an integer array
        mask = label(mask, background=0, connectivity=2)
        # Measure properties of labeled image regions.
        txt_regions = regionprops(mask)
        return txt_regions

    def _get_txt_bboxes(self, txt_regions: List[RegionProperties]) -> List[Tuple[int, int, int, int]]:
        """ Filter text area by area and height

            :return: ``[(ymin, xmin, ymax, xmax)]``
        """
        min_area = 0
        min_height = 4
        boxes = []
        for p in txt_regions:
            if p.area > min_area:
                bbox = p.bbox
                if (bbox[2] - bbox[0]) > min_height:
                    boxes.append(bbox)
        return boxes

    def decode(self) -> List[Tuple[int, int, int, int]]:
        """ Decode PixelLink's output

            :return: bounding_boxes

            .. note::
                bounding_boxes format: [ymin ,xmin ,ymax, xmax]

        """
        mask = self.get_mask()
        bboxes = self._get_txt_bboxes(self._get_txt_regions(mask))
        # sort by xmin, ymin
        bboxes = sorted(bboxes, key=lambda x: (x[1], x[0]))
        return bboxes
