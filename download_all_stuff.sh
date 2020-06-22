#!/bin/bash

# colors
end="\033[0m"
red="\033[0;31m"
green="\033[0;32m"

green () {
  echo -e "${green}${1}${end}"
}

red () {
  echo -e "${red}${1}${end}"
}

green "DOWNLOAD ALL ARCHIVES"
wget -c https://github.com/opencv/opencv/archive/4.3.0.tar.gz -O opencv.tar.gz
wget -c https://github.com/openvinotoolkit/openvino/archive/2020.3.0.tar.gz -O dldt.tar.gz
wget -c https://github.com/FFmpeg/FFmpeg/archive/n4.3.tar.gz -O ffmpeg.tar.gz
wget -c https://github.com/xianyi/OpenBLAS/archive/v0.3.10.tar.gz -O openblas.tar.gz


green "CLEAN LIB DIRS"
rm -drf ./dldt/*
rm -drf ./ffmpeg/*
rm -drf ./opencv/*
rm -drf ./openblas/*

green "CLEAN BUILD DIRS"
find build/dldt/ -mindepth 1 -not -name 'dldt_setup.sh' -delete
find build/opencv/ -mindepth 1 -not -name 'opencv_setup.sh' -delete
find build/ffmpeg/ -mindepth 1 -not -name 'ffmpeg_*.sh' -delete
find build/openblas/ -mindepth 1 -not -name 'openblas_setup.sh' -delete

green "CLEAN WHEEL DIR"
find create_wheel/cv2/ -type f -not -name '__init__.py' -delete
rm -drf create_wheel/build
rm -drf create_wheel/dist
rm -drf create_wheel/*egg-info

green "UNZIP ALL STUFF"
tar -xf opencv.tar.gz --strip-components=1 -C ./opencv/
tar -xf dldt.tar.gz --strip-components=1 -C ./dldt/
tar -xf ffmpeg.tar.gz --strip-components=1 -C ./ffmpeg/
tar -xf openblas.tar.gz --strip-components=1 -C ./openblas/

green "GIT RESET FOR ade"
cd ./dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard cbe2db6

green "GIT RESET FOR ngraph"
cd ../../../ngraph
git clone https://github.com/NervanaSystems/ngraph ./
git reset --hard edc65ca

green "CREATE VENV"
cd ../

if [[ ! -d ./venv ]]; then
	virtualenv --clear --always-copy -p /usr/bin/python3 ./venv
	./venv/bin/pip3 install numpy
fi
