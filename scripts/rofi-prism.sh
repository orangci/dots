#!/usr/bin/env bash

# Define the instances directory
INSTANCES_DIR="$HOME/.local/share/PrismLauncher/instances"

# Function to generate rofi options
generate_rofi_options() {
    for instance in "$INSTANCES_DIR"/*/; do
        # Extract the instance folder name
        instance_name=$(basename "$instance")
        # Define the path to the icon
        icon_path="$instance/.minecraft/icon.png"
        # Ensure the icon exists, otherwise use a placeholder
        if [[ ! -f "$icon_path" ]]; then
            icon_path="/path/to/default/icon.png"  # Replace with a default icon path
        fi
        # Print the rofi option
        echo -e "$instance_name\0icon\x1f$icon_path"
    done
}

# Function to execute the selected instance
execute_instance() {
    local selected_instance="$1"
    prismlauncher -l "$selected_instance"
}

# Generate the rofi options and capture the selected instance
selected_instance=$(generate_rofi_options | rofi -dmenu -theme selector.rasi)

# If a selection was made, execute the instance
if [[ -n "$selected_instance" ]]; then
    execute_instance "$selected_instance"
fi
