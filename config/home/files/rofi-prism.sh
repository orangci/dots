#!/usr/bin/env bash

# Define your Prism Launcher instances
declare -A instances=(
  ["Juniper"]="Juniper"
  ["MCCI"]="MCCI"
  ["Vanilla 1.20.1"]="JuniperVanilla"
)

# Generate the options for Rofi
options=""
for instance in "${!instances[@]}"; do
  options+="$instance\n"
done

# Show Rofi menu and get the selected instance
selected_instance=$(echo -e "$options" | rofi -dmenu -p "Select Prism Launcher Instance" -theme clipboard.rasi)

# Launch the selected instance
if [[ -n "${instances[$selected_instance]}" ]]; then
  prismlauncher -l "${instances[$selected_instance]}"
else
  echo "Invalid selection" "No such instance: $selected_instance"
fi