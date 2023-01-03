import unittest
import cv2
from pixellink import PixelLinkDetector
from text_recognition import TextRecognizer
from rateme.utils import RateMe


class TestPackage(unittest.TestCase):

    def test_dnn_module(self):
        model = RateMe()
        img = cv2.imread('../tests/dislike.jpg')
        answer = model.predict(img)
        self.assertEqual(answer, 'dislike')
        print('rateme: passed')

    def test_inference_engine(self):
        img = cv2.imread('../tests/helloworld.png')
        detector4 = PixelLinkDetector('text-detection-0004.xml')
        detector4.detect(img)
        bboxes = detector4.decode()

        recognizer12 = TextRecognizer('intel/text-recognition-0012/FP32/text-recognition-0012.xml')
        answer = recognizer12.do_ocr(img, bboxes)
        self.assertEqual(answer, ['hello', 'world'])
        print('text detection and recognition: passed')


if __name__ == '__main__':
    unittest.main()
