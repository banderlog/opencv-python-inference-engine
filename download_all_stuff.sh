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

green "DOWNLOAD ALL STUFF"
wget -c https://github.com/opencv/opencv/archive/4.2.0.tar.gz
wget -c https://github.com/FFmpeg/FFmpeg/archive/n4.2.2.tar.gz
wget -c https://github.com/opencv/dldt/archive/2020.1.tar.gz
#wget -c https://github.com/intel/mkl-dnn/releases/download/v0.19/mklml_lnx_2019.0.5.20190502.tgz

green "CLEAN LIB DIRS"
rm -drf ./dldt/*
rm -drf ./ffmpeg/*
rm -drf ./opencv/*
rm -drf ./mklml_lnx/*

green "UNZIP ALL STUFF"
tar -xf 2020.1.tar.gz --strip-components=1 -C ./dldt/
tar -xf n4.2.2.tar.gz --strip-components=1 -C ./ffmpeg/
tar -xf 4.2.0.tar.gz --strip-components=1 -C ./opencv/
#tar -xf mklml_lnx_2019.0.5.20190502.tgz --strip-components=1 -C ./mklml_lnx/

green "GIT RESET FOR ade"
cd ./dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard cbe2db6

green "GIT RESET FOR ngraph"
cd ../../../ngraph
git clone https://github.com/NervanaSystems/ngraph ./
git reset --hard b0bb801

green "CREATE VENV"
cd ../../

if [[ ! -d ./venv ]]; then
	virtualenv --clear --always-copy -p /usr/bin/python3 ./venv
	./venv/bin/pip3 install numpy
fi
