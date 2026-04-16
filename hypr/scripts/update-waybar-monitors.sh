#!/bin/bash
ULTRAWIDE=$(hyprctl monitors -j | python3 -c "
import json,sys
monitors = json.load(sys.stdin)
for m in monitors:
    if 'PL3480WQ' in m['description']:
        print(m['name'])
")

sed -i "s/\"output\": \"DP-[0-9]*\"/\"output\": \"$ULTRAWIDE\"/" ~/.config/waybar/config
sed -i "s/\"output\": \"!DP-[0-9]*\"/\"output\": \"!$ULTRAWIDE\"/" ~/.config/waybar/config
