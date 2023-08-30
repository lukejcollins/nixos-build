# Variables to hold workspaces for each monitor
workspaces_eDP1=""
workspaces_DP2=""

# Get active workspaces for each monitor
active_workspace_eDP1=$(hyprctl monitors | grep -A9 'Monitor eDP-1' | grep 'active workspace' | awk '{print $3}')
active_workspace_DP2=$(hyprctl monitors | grep -A9 'Monitor DP-2' | grep 'active workspace' | awk '{print $3}')

# Loop through all workspaces to fill workspace strings for each monitor
while read -r line; do
  monitor=$(echo "$line" | awk -F'on monitor ' '{print $2}' | awk '{print $1}' | sed 's/://')
  workspace=$(echo "$line" | awk '{print $3}')

  if [[ "$monitor" == "eDP-1" ]]; then
    if [[ "$workspace" == "$active_workspace_eDP1" ]]; then
      workspaces_eDP1+="[$workspace*]"
    else
      workspaces_eDP1+="[$workspace]"
    fi
  elif [[ "$monitor" == "DP-2" ]]; then
    if [[ "$workspace" == "$active_workspace_DP2" ]]; then
      workspaces_DP2+="[$workspace*]"
    else
      workspaces_DP2+="[$workspace]"
    fi
  fi
done < <(hyprctl workspaces | grep 'workspace ID')

# Get the remaining battery percentage and status
battery_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

# Aggregate the notifications
notification_text=" $workspaces_eDP1\n"

if [[ -n "$workspaces_DP2" ]]; then
  notification_text+=" $workspaces_DP2\n"
fi

# Add battery information
battery_notification=$(printf "%s%% (%s)" "$battery_capacity" "$battery_status")
notification_text+=" $battery_notification"

# Get the current time
current_time=$(date '+%H:%M:%S')

# Get the current date in the desired format
current_date=$(date '+%Y-%m-%d')

# Send the consolidated notification with time
notify-send -t 4000 "Status @ $current_time on $current_date" "$notification_text"
