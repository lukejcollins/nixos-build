#!/bin/bash

# Get the workspace of the currently focused container
workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Path to the file where we store the current split direction for this workspace
split_file=~/.sway_split_direction_$workspace

# If the file doesn't exist, create it and set the initial split direction to horizontal
if [ ! -f "$split_file" ]; then
	echo "splith" >"$split_file"
fi

# Read the current split direction from the file
split_direction=$(cat "$split_file")

# Toggle the split direction
if [ "$split_direction" = "splith" ]; then
	swaymsg splitv
	echo "splitv" >"$split_file"
else
	swaymsg splith
	echo "splith" >"$split_file"
fi
