#!/usr/bin/env bash

# Define the URLs and commands
declare -A URLS=(
    ["🌎 Search"]="https://search.brave.com/search?q="
    ["❄️ Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
    ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
    ["📜 MAL"]="https://myanimelist.net/anime.php?cat=anime&q="
    ["🎨 Catppuccin Colors"]="catppuccin_colors"  # This is the new option for Catppuccin colors
)

# List for rofi
gen_list() {
    for i in "${!URLS[@]}"
    do
        echo "$i"
    done
}

# Function to handle Catppuccin Colors selection
catppuccin_colors() {
    # Define the colors
    declare -A COLORS=(
        ["Rosewater"]="#f5e0dc"
        ["Flamingo"]="#f2cdcd"
        ["Pink"]="#f5c2e7"
        ["Mauve"]="#cba6f7"
        ["Red"]="#f38ba8"
        ["Maroon"]="#eba0ac"
        ["Peach"]="#fab387"
        ["Yellow"]="#f9e2af"
        ["Green"]="#a6e3a1"
        ["Teal"]="#94e2d5"
        ["Sky"]="#89dceb"
        ["Sapphire"]="#74c7ec"
        ["Blue"]="#89b4fa"
        ["Lavender"]="#b4befe"
        ["Text"]="#cdd6f4"
        ["Subtext1"]="#bac2de"
        ["Subtext0"]="#a6adc8"
        ["Overlay2"]="#9399b2"
        ["Overlay1"]="#7f849c"
        ["Overlay0"]="#6c7086"
        ["Surface2"]="#585b70"
        ["Surface1"]="#45475a"
        ["Surface0"]="#313244"
        ["Base"]="#1e1e2e"
        ["Mantle"]="#181825"
        ["Crust"]="#11111b"
    )

    # Generate list of color names for rofi
    color_name=$(for name in "${!COLORS[@]}"; do echo "$name"; done | rofi -dmenu -theme clipboard.rasi -p "Select a color:")

    if [[ -n "$color_name" ]]; then
        color_value="${COLORS[$color_name]}"
        echo -n "$color_value" | wl-copy
    else
        exit
    fi
}

main() {
    # Pass the list to rofi
    platform=$( (gen_list) | rofi -dmenu -theme clipboard.rasi)

    if [[ -n "$platform" ]]; then
        if [[ "$platform" == "🎨 Catppuccin Colors" ]]; then
            catppuccin_colors
        else
            query=$(rofi -dmenu -p "Search query:")

            if [[ -n "$query" ]]; then
                url="${URLS[$platform]}$query"
                xdg-open "$url"
            else
                exit
            fi
        fi
    else
        exit
    fi
}

main
