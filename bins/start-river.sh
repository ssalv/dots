#!/bin/sh

# --- Session settings ---
export XDG_CURRENT_DESKTOP=wlroots
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=wlroots

# Hardware cursors not yet working on wlroots
export WLR_NO_HARDWARE_CURSORS=1

# General wayland environment variables
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# Firefox wayland environment variable
export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1

# Starting dbus-session might require hard path.
exec river
