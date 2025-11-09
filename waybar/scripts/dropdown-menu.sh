#!/bin/bash

# Menu options
options="🔵 Bluetooth\n🔌 Power Menu\n📋 Clipboard\n🎨 Color Picker\n📸 Screenshot\n⚙️ Settings"

# Show menu with wofi
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Quick Menu" --width 300 --height 250)

# Handle selection
case $chosen in
    "🔵 Bluetooth")
        blueman-manager
        ;;
    "🔌 Power Menu")
        ~/.config/waybar/scripts/power-menu.sh
        ;;
    "📋 Clipboard")
        cliphist list | wofi --dmenu | cliphist decode | wl-copy
        ;;
    "🎨 Color Picker")
        hyprpicker -a
        ;;
    "📸 Screenshot")
        grim -g "$(slurp)" - | wl-copy
        ;;
    "⚙️ Settings")
        # Add your settings manager here
        ;;
esac
