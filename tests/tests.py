import unittest
import cv2
from pixellink import PixelLinkDetector
from text_recognition import TextRecognizer
from rateme.utils import RateMe


class TestPackage(unittest.TestCase):

    def test_dnn_module(self):
        model = RateMe()
        img = cv2.imread('dislike.jpg')
        answer = model.predict(img)
        self.assertEqual(answer, 'dislike')

    def test_inference_engine(self):
        img = cv2.imread('helloworld.png')
        detector4 = PixelLinkDetector('text-detection-0004.xml')
        detector4.detect(img)
        bboxes = detector4.decode()

        recognizer12 = TextRecognizer('./text-recognition-0012.xml')
        answer = recognizer12.do_ocr(img, bboxes)
        self.assertEqual(answer, ['hello', 'world'])

    def test_ffmpeg(self):
        cap = cv2.VideoCapture('short_video.mp4')
        answer, img = cap.read()
        self.assertTrue(answer)


if __name__ == '__main__':
    unittest.main()
