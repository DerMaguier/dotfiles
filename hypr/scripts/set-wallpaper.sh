#!/bin/bash
# ~/.config/hypr/scripts/set-wallpaper.sh
# Użycie: set-wallpaper.sh /ścieżka/do/obrazu.jpg

WALLPAPER="${1:-$HOME/Downloads/ToriGate.jpg}"


pkill -x gslapper 2>/dev/null
gslapper -o "fill" "*" "$WALLPAPER" &
echo "$WALLPAPER" > ~/.config/hypr/current-wallpaper

wal -i "$WALLPAPER" -n  


source ~/.cache/wal/colors.sh
R=$(printf '%d' 0x${background:1:2})
G=$(printf '%d' 0x${background:3:2})
B=$(printf '%d' 0x${background:5:2})
R2=$(printf '%d' 0x${color2:1:2})
G2=$(printf '%d' 0x${color2:3:2})
B2=$(printf '%d' 0x${color2:5:2})

cat > ~/.cache/wal/colors-rofi-alpha.rasi << EOF
* {
    bg-alpha:       rgba(${R}, ${G}, ${B}, 0.5);
    bg-alpha-low:   rgba(${R}, ${G}, ${B}, 0.3);
    accent-alpha:   rgba(${R2}, ${G2}, ${B2}, 0.4);
}
EOF

pkill -x waybar 2>/dev/null
waybar &


timeout 10 bash -c 'until hyprctl clients 2>/dev/null | grep -q waybar || pgrep -x waybar > /dev/null; do sleep 0.3; done'
sleep 1.5  


pkill -x nm-applet 2>/dev/null
nm-applet --indicator &

SDDM_BG="/usr/share/sddm/themes/sugar-dark/wallpaper.jpg"

if [[ "$WALLPAPER" == *.mp4 ]]; then
    ffmpeg -i "$WALLPAPER" -vframes 1 -q:v 2 /tmp/sddm-wallpaper.jpg -y 2>/dev/null
    sudo cp /tmp/sddm-wallpaper.jpg "$SDDM_BG"
else
    sudo cp "$WALLPAPER" "$SDDM_BG"
fi
