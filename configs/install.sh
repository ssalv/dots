#!/bin/sh

CR='\033[0;31m'; CG='\033[0;32m'; CY='\033[0;36m'; CB='\033[0;34m'; CRE='\033[0m'

[ "$(id -u)" -ne 0 ] || {
    printf "${CR}Do not run this script with root privileges! Exiting...${CRE}\n"
    exit 1
}

if ! command -v stow >/dev/null 2>&1
then
    printf "${CR}Missing Stow Exiting...${CRE}\n"
    exit 1

fi
mkdir -p ~/{.ssh,.gnupg}
mkdir -p ~/.config

mkdir -p ~/.local/bin
stow -v -R -d .. -t ~/.local/bin bins
chmod +x ~/.local/bin/start-dwl.sh
chmod +x ~/.local/bin/dwl-startup.sh

mkdir -p ~/{dev,Download,Notes,Pictures,Music,Vids,Misc}
stow -v -R -t ~/.config/ user-dirs

mkdir -p ~/Pictures/Wallpapers
stow -v -R -d ../assets -t ~/Pictures/Wallpapers Wallpapers

mv ~/.config/foot ~/.config/foot_bck
mkdir -p ~/.config/foot
stow -v -R -t ~/.config/foot foot
