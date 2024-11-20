#!/bin/bash

# Clear Screen
tput reset 2>/dev/null || clear

# Colours (or Colors in en_US)
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NORMAL='\033[0m'

# Abort Function
function abort(){
    [ ! -z "$@" ] && echo -e ${RED}"${@}"${NORMAL}
    exit 1
}

# Banner
function __bannerTop() {
	echo -e \
	${GREEN}"
	██████╗░██╗░░░██╗███╗░░░███╗██████╗░██████╗░██╗░░██╗
	██╔══██╗██║░░░██║████╗░████║██╔══██╗██╔══██╗╚██╗██╔╝
	██║░░██║██║░░░██║██╔████╔██║██████╔╝██████╔╝░╚███╔╝░
	██║░░██║██║░░░██║██║╚██╔╝██║██╔═══╝░██╔══██╗░██╔██╗░
	██████╔╝╚██████╔╝██║░╚═╝░██║██║░░░░░██║░░██║██╔╝╚██╗
	╚═════╝░░╚═════╝░╚═╝░░░░░╚═╝╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚═╝
	"${NC}
}

# Welcome Banner
printf "\e[32m" && __bannerTop && printf "\e[0m"

# Minor Sleep
sleep 1

if [[ "$OSTYPE" == "linux-gnu" ]]; then

    if [[ "$(command -v apt)" != "" ]]; then
        sudo apt update
        sudo apt upgrade -y
        echo -e ${PURPLE}"Ubuntu/Debian Based Distro Detected"${NORMAL}
        sleep 1
        echo -e ${BLUE}">> Updating apt repos..."${NORMAL}
        sleep 1
	    sudo apt -y update || abort "Setup Failed!"
	    sleep 1
	    echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
	    sleep 1
        sudo apt install -y unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract device-tree-compiler liblzma-dev python3-pip brotli liblz4-tool axel gawk aria2 detox cpio rename liblz4-dev jq neofetch git-lfs || abort "Setup Failed!"
        sudo apt install -y aria2 arj brotli cabextract cmake device-tree-compiler gcc g++ git liblz4-tool liblzma-dev libtinyxml2-dev lz4 mpack openjdk-11-jdk p7zip-full p7zip-rar python3 python3-pip rar sharutils unace unrar unzip uudeview xz-utils zip zlib1g-dev git-lfs || abort "Setup Failed!"

 elif [[ "$(command -v dnf)" != "" ]]; then
        echo -e ${PURPLE}"Fedora Based Distro Detected"${NORMAL}
        sleep 1
	    echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
	    sleep 1

	    # "dnf" automatically updates repos before installing packages
        sudo dnf install -y unace unrar zip unzip sharutils uudeview arj cabextract file-roller dtc python3-pip brotli axel aria2 detox cpio lz4 python3-devel xz-devel p7zip p7zip-plugins git-lfs || abort "Setup Failed!"

    elif [[ "$(command -v pacman)" != "" ]]; then
        echo -e ${PURPLE}"Arch or Arch Based Distro Detected"${NORMAL}
        sleep 1
	    echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
	    sleep 1

        sudo pacman -Syyu --needed --noconfirm 2>&1 | grep -v "warning: could not get file information" || abort "Setup Failed!"
        sudo pacman -Sy --noconfirm unace unrar zip unzip p7zip sharutils uudeview arj cabextract file-roller dtc brotli axel gawk aria2 detox cpio lz4 jq || abort "Setup Failed!"

        # Python
        sleep 1
        echo -e ${BLUE}">> Creating Required Python3 Symlinks..."${NORMAL}
        sleep 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e ${PURPLE}"macOS Detected"${NORMAL}
    sleep 1
	echo -e ${BLUE}">> Installing Required Packages..."${NORMAL}
	sleep 1
    brew install protobuf xz brotli lz4 aria2 detox coreutils p7zip gawk git-lfs || abort "Setup Failed!"
fi

sleep 1
echo -e ${PURPLE}"Distro Specific Setup Done, Now Installing pyhton Packages from pip..."${NORMAL}
sleep 1
[[ "${USE_VENV}" == "false" || "${USE_VENV}" == "0" ]] || {
    python3 -m venv .venv
    [ -e ".venv" ] && source .venv/bin/activate
}
pip install backports.lzma extract-dtb  pycryptodome docopt zstandard twrpdtgen future requests humanize clint lz4 pycryptodome pycryptodomex || abort "Setup Failed!"
pip install --force-reinstall -v "protobuf==3.20.0"
pip install git+https://github.com/sebaubuntu-python/aospdtgen || abort "Setup Failed!"
sleep 1

# Done!
echo -e ${GREEN}"Setup Complete!"${NORMAL}
# Exit
exit 0
