#!/bin/bash

# Kill already running dublicate process
_ps="dwlb foot swaybg swayidle"
for _prs in $_ps; do
    if [ "$(pidof "${_prs}")" ]; then
         killall -9 "${_prs}"
    fi
 done

# Start our applications
swaybg -i ~/Pictures/Wallpapers/gentoo-abducted-1680x1050.png -m fill -c 0000a3 &
dwlb -no-active-color-title &
swayidle -w \
         timeout 300 'swaylock --daemonize -c ~/.config/swaylock/config' \
         timeout 200 'brightnessctl s 20%' resume 'brightnessctl s 50%' \
         before-sleep 'swaylock --daemonize -c ~/.config/swaylock/config' &

exec gnome-keyring-daemon --start --components=secrets &
exec export ${gnome-keyring-daemon} &

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

i3status | dwlb -status-stdin all &

exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

sleep 1

gsettings set org.gnome.desktop.interface gtk-theme 'minidark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
