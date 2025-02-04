#!/bin/bash

# Path to your Markdown file
file_path="$HOME/dots/hm-modules/programs/hyprland/hyprlock/quotes.md"

# Check if the file exists
if [[ ! -f "$file_path" ]]; then
    echo "File not found: $file_path"
    exit 1
fi

# Extract lines starting with '- ' and remove the leading '- ' using sed
quotes=()
while IFS= read -r line; do
    quotes+=("$line")
done < <(sed -n 's/^- //p' "$file_path")

# Check if any quotes were found
if [[ ${#quotes[@]} -eq 0 ]]; then
    echo "No quotes found in the file."
    exit 1
fi

# Select a random quote
random_quote="${quotes[RANDOM % ${#quotes[@]}]}"

# Write the quote to /tmp/hyprlock_quote
# echo "\$QOTD=$random_quote" > /tmp/hyprlock_quote
echo $random_quote
