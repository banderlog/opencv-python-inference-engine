#!/bin/bash

green="\033[0;32m"
red="\033[0;31m"
end="\033[0m"

green () {
  echo -e "${green}${1}${end}"
}

red () {
  echo -e "${red}${1}${end}"
}


echo "======================================================================"
green "CREATE VENV WITH OPENCV AND OPENVINO RUNTIME"
if [ ! -d ./venv_t ]; then
	virtualenv --clear --always-copy -p /usr/bin/python3 ./venv_t
fi
green "CREATE SEPARATE VENV WITH OPENVINO DEV TO USE MODEL DOWNLOADER"
if [ ! -d ./venv_d ]; then
	virtualenv --clear --always-copy -p /usr/bin/python3 ./venv_d
fi


green "INSTALLING DEPENDENCIES"
./venv_t/bin/pip3 install -r requirements.txt
./venv_d/bin/pip3 install openvino-dev==2022.3.0


green "GET MODELS"
if [ ! -f "rateme-0.1.1.tar.gz" ]; then
    wget "https://github.com/banderlog/rateme/releases/download/v0.1.1/rateme-0.1.1.tar.gz"
fi
    ./venv_t/bin/pip3 install --no-deps "rateme-0.1.1.tar.gz"

# download models from intel
if [ ! -f "intel/text-recognition-0012/FP32/text-recognition-0012.bin" ]; then
	./venv_d/bin/omz_downloader --precision FP32 -o ./ --name text-recognition-0012
fi

# particularly that new model does not work or something changed in decoder
declare -a models=("text-detection-0004.xml"
                   "text-detection-0004.bin")

url_start="https://download.01.org/opencv/2020/openvinotoolkit/2020.1/open_model_zoo/models_bin/1"

for i in "${models[@]}"; do
    # if no such file
    if [ ! -f $i ]; then
	# download
        wget "${url_start}/${i%.*}/FP32/${i}"
    else
	# checksum
        sha256sum -c "${i}.sha256sum" || red "PROBLEMS ^^^"
    fi
done



green "For \"$WHEEL\""
green "RUN TESTS with ./venv_t/bin/python ./tests.py"
./venv_t/bin/python ./tests.py
