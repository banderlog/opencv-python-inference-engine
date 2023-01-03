Only way to download models -- through model downloader, no manual download anymore:
- <https://github.com/openvinotoolkit/open_model_zoo/blob/releases/2022/3/tools/model_tools/README.md>
- <https://github.com/openvinotoolkit/open_model_zoo/blob/releases/2022/3/models/intel/index.md>
- <https://github.com/openvinotoolkit/open_model_zoo/blob/releases/2022/3/models/public/index.md>
- <https://github.com/openvinotoolkit/open_model_zoo/>

Sometimes models are backwards compatible to new OpenVINO version, sometimes no.
Sometimes new model versions became unworkable.

IE API for network upload and usage now deprecated, one should use openvino API instead:
- see differences of `pixellink.py` and `text_recognition.py` between `tests` and `tests_openvino` folders
- <https://docs.openvino.ai/latest/notebooks/002-openvino-api-with-output.html>
