#!/bin/bash
# usage: focus-or-launch.sh <class_regex> <title_regex> <launch_command>
# title_regex "" can be used to match to class only

CLASS="$1"
TITLE="$2"
CMD="$3"

if [ -n "$TITLE" ]; then
    FOUND=$(hyprctl clients -j | jq -r \
        --arg c "$CLASS" --arg t "$TITLE" \
        '.[] | select(.class | test($c; "i")) | select(.title | test($t; "i")) | .address' \
        | head -1)
else
    FOUND=$(hyprctl clients -j | jq -r \
        --arg c "$CLASS" \
        '.[] | select(.class | test($c; "i")) | .address' \
        | head -1)
fi

if [ -n "$FOUND" ]; then
    hyprctl dispatch focuswindow "address:$FOUND"
else
    hyprctl dispatch exec "$CMD"
fi
