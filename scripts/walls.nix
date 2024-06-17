{ pkgs }:
pkgs.writeShellScriptBin "wallset" ''
# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/walls-catppuccin-mocha"

# Function to select and set a random wallpaper
set_random_wallpaper() {
  # Select a random file from the wallpaper directory
  RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
  
  # Set the wallpaper using hyprpaper
  hyprpaper --wallpaper "$RANDOM_WALLPAPER"
}

# Set an initial wallpaper
set_random_wallpaper

# Loop to change the wallpaper every 5 minutes
while true; do
  sleep 300 # 300 seconds = 5 minutes
  set_random_wallpaper
done

''
