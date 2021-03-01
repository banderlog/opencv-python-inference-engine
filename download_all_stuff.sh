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


ROOT_DIR=$(pwd)

# check Ubuntu version (20.04 build will not work on 18.04)
if test $(lsb_release -rs) != 18.04; then
    red "\n!!! You are NOT on the Ubuntu 18.04 !!!\n"
fi

green "RESET GIT SUBMODULES"
# use `git fetch --unshallow && git checkout tags/<tag>` for update
git submodule update --init --recursive --depth=1 --jobs=4
# restore changes
git submodule foreach --recursive git restore .
# remove untracked
git submodule foreach --recursive git clean -dxf

green "CLEAN BUILD DIRS"
find build/dldt/ -mindepth 1 -not -name 'dldt_setup.sh' -not -name '*.patch' -delete
find build/opencv/ -mindepth 1 -not -name 'opencv_setup.sh' -delete
find build/ffmpeg/ -mindepth 1 -not -name 'ffmpeg_*.sh' -delete
find build/openblas/ -mindepth 1 -not -name 'openblas_setup.sh' -delete

green "CLEAN WHEEL DIR"
find create_wheel/cv2/ -type f -not -name '__init__.py' -delete
rm -drf create_wheel/build
rm -drf create_wheel/dist
rm -drf create_wheel/*egg-info

green "CREATE VENV"
cd $ROOT_DIR

if [[ ! -d ./venv ]]; then
	virtualenv --clear --always-copy -p /usr/bin/python3 ./venv
	./venv/bin/pip3 install -r requirements.txt
fi
