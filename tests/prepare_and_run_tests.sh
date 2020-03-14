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

# check if (no ARG and no some appropriate files are compiled) or
# (some args provided but arg1 is not existing file)
# of course, you could shoot your leg here in different ways
if ([ ! $# -ge 1 ] && ! $(ls ../create_wheel/dist/opencv_python_inference_engine*.whl &> /dev/null)) ||
   ([ $# -ge 1 ] && [ ! -f $1 ]); then
        red "How do you suppose to run wheel tests without wheel?"
    red "Compile it or provide as an ARG1 to script"
    exit 1
fi


green "CREATE SEPARATE TEST VENV"
if [ ! -d ./venv_t ]; then
	virtualenv --clear --always-copy -p /usr/bin/python3 ./venv_t
fi


green "INSTALLING DEPENDENCIES"
if [ $1 ]; then
    # install ARGV1
    green "Installing from provided path"
    ./venv_t/bin/pip3 install --force-reinstall "$1"
else
    # install compiled wheel
    green "Installing from default path"
    ./venv_t/bin/pip3 install --force-reinstall ../create_wheel/dist/opencv_python_inference_engine*.whl
fi

./venv_t/bin/pip3 install -r requirements.txt


green "GET MODELS"

if [ ! -d "rateme" ]; then
    ./venv_t/bin/pip3 install --python-version 3 rateme -U --no-deps -t ./
fi

# urls, filenames and checksums are from:
#  + <https://github.com/opencv/open_model_zoo/blob/2020.1/models/intel/text-detection-0004/model.yml>
#  + <https://github.com/opencv/open_model_zoo/blob/2020.1/models/intel/text-recognition-0012/model.yml>
declare -a models=("text-detection-0004.xml"
                   "text-detection-0004.bin"
                   "text-recognition-0012.xml"
                   "text-recognition-0012.bin")

url_start="https://download.01.org/opencv/2020/openvinotoolkit/2020.1/open_model_zoo/models_bin/1"

for i in "${models[@]}"; do
    if [ ! -f $i ]; then
        wget "${url_start}/${i%.*}/FP32/${i}"
    else
        sha256sum -c "${i}.sha256sum"
    fi
done


green "RUN TESTS with ./venv_t/bin/python ./tests.py"
./venv_t/bin/python ./tests.py
