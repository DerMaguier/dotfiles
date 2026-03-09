#!/bin/bash
# ~/.config/hypr/scripts/waybar-media.sh
# Wywoływany co 1s przez waybar (interval: 1)
# Scroll o SCROLL_STEP znaków na wywołanie

MAX_LEN=50
SCROLL_STEP=3  # znaki przesunięcia na sekundę — zwiększ dla szybszego scrollu

SCROLL_FILE="/tmp/waybar-media-pos"
OWL_FILE="/tmp/waybar-owl-tick"

OWL_FRAMES=("(OwO)" "(OwO)" "(OwO)" "(-w-)" "(-w-)" "(OwO)" "(OwO)" "(OwO)" "(OwO)" "(owo)" "(OwO)" "(OwO)" "( ._. )" "(OwO)" "(OwO)")
OWL_TICKS_PER_FRAME=15  # sekund na zmianę klatki sowy

get_music() {
    local status
    status=$(playerctl status 2>/dev/null)
    [[ "$status" != "Playing" && "$status" != "Paused" ]] && echo "" && return

    local artist title album
    artist=$(playerctl metadata xesam:artist 2>/dev/null)
    title=$(playerctl metadata xesam:title 2>/dev/null)
    album=$(playerctl metadata xesam:album 2>/dev/null)

    [[ -z "$album" && -z "$artist" ]] && echo "" && return

    if [[ -n "$artist" && -n "$title" ]]; then
        echo "$artist - $title"
    elif [[ -n "$title" ]]; then
        echo "$title"
    else
        echo ""
    fi
}

MUSIC=$(get_music)

if [[ -z "$MUSIC" ]]; then
    # Sowa
    tick=0
    [[ -f "$OWL_FILE" ]] && tick=$(cat "$OWL_FILE")
    frame=$(( tick / OWL_TICKS_PER_FRAME % ${#OWL_FRAMES[@]} ))
    echo $(( tick + 1 )) > "$OWL_FILE"
    # Wyczyść pozycję scrollu
    rm -f "$SCROLL_FILE"
    echo "${OWL_FRAMES[$frame]}"
    exit 0
fi

# Reset scrollu przy zmianie utworu
TEXT_HASH=$(echo "$MUSIC" | md5sum | cut -c1-8)
HASH_FILE="/tmp/waybar-media-hash"
prev_hash=""
[[ -f "$HASH_FILE" ]] && prev_hash=$(cat "$HASH_FILE")

if [[ "$TEXT_HASH" != "$prev_hash" ]]; then
    echo "$TEXT_HASH" > "$HASH_FILE"
    echo "0" > "$SCROLL_FILE"
    rm -f "$OWL_FILE"
fi

local_len=${#MUSIC}

if (( local_len <= MAX_LEN )); then
    echo "$MUSIC"
    exit 0
fi

# Scroll
padded="$MUSIC   •   "
plen=${#padded}

pos=0
[[ -f "$SCROLL_FILE" ]] && pos=$(cat "$SCROLL_FILE")

result=""
for ((i=0; i<MAX_LEN; i++)); do
    idx=$(( (pos + i) % plen ))
    result+="${padded:$idx:1}"
done

next_pos=$(( (pos + SCROLL_STEP) % plen ))
echo "$next_pos" > "$SCROLL_FILE"

echo "$result"
