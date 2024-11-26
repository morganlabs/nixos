#!/usr/bin/env bash

SAVE_TO="$HOME/Pictures/Screenshots/$(date +'%Y/%m/Screenshot_%d-%H-%M-%S.png')"
mkdir -p "$(dirname "$SAVE_TO")"

ACTION="$1"

grab_window() {
    pkill slurp
    monitors="$(hyprctl -j monitors)"
    clients="$(hyprctl -j clients | jq -r '[.[] | select(.workspace.id | contains('"$(echo "$monitors" | jq -r 'map(.activeWorkspace.id) | join(",")')"'))]')"
	boxes="$(echo "$clients" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' | cut -f1,2 -d' ')"
	slurp -r <<< "$boxes"
}

screenshot() {
	grim "$@" "$SAVE_TO"
	wl-copy < "$SAVE_TO"
	notify-send --app-name="Screenshot" --icon="$SAVE_TO" "Screenshot saved" "$SAVE_TO"
}

case "$ACTION" in
	"selection")
        pkill slurp
        geometry="$(slurp)"
        [[ "$?" -ne 0 ]] && exit 0
		screenshot -g "$geometry"
	;;
	"window")
        geometry="$(grab_window)"
        [[ "$?" -ne 0 ]] && exit 0
		screenshot -g "$geometry"
	;;
	"all")
		screenshot
	;;
	*)
		echo "Please choose an option."
		exit 1
	;;
esac
