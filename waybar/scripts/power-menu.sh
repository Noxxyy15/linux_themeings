#!/bin/bash

options="⏻ Shutdown\n🔄 Reboot\n🔒 Lock\n🚪 Logout\n😴 Sleep"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu" --width 250 --height 200)

case $chosen in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "🔒 Lock")
        hyprlock # or swaylock
        ;;
    "🚪 Logout")
        hyprctl dispatch exit
        ;;
    "😴 Sleep")
        systemctl suspend
        ;;
esac
