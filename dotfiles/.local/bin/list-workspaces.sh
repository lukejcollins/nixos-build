# Get the active workspace
active_workspace=$(hyprctl monitors | grep active | awk '{print $3}')

# Get all workspaces and mark the active one
workspaces=$(hyprctl workspaces | awk -v active="$active_workspace" -v ORS="" '/workspace ID/ { if ($3 == active) printf "[%s*]", $3; else printf "[%s]", $3 }')

# Get the remaining battery percentage and status
battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

# Create notifications
workspace_notification=$(printf "%s" "$workspaces")
battery_notification=$(printf "%s%% (%s)" "$battery_capacity" "$battery_status")

# Send notifications
notify-send -t 2000 "Workspaces" "$workspace_notification"
notify-send -t 2000 "Battery" "$battery_notification"
