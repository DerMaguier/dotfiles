#!/bin/bash
gslapper -o "fill" "*" ~/Downloads/ToriGate.jpg &
wal -i ~/Downloads/ToriGate.jpg
killall waybar
waybar &
sleep 2
killall nm-applet
nm-applet --indicator &
