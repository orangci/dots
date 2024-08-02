#!/usr/bin/env bash

if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "deez" > /dev/null
else
  echo "This is not NixOS or the distribution information is not available; this installation script only works for NixOS."
  exit
fi

if command -v git &> /dev/null; then
  echo "nuts" > /dev/null
else
  nix-shell -p git
fi


# Step 1: cd to $HOME
cd $HOME || exit

# Step 2: Clone the repository
echo "Cloning repository..."
git clone https://github.com/orxngc/dots
cd dots || exit
echo "orxngc/dots cloned successfully."

# Step 3: Ask the user for their username and replace all instances of "orangc"
read -p "Enter your username: " username
grep -rl "orangc" . | xargs sed -i "s/orangc/$username/g"

# Step 4: Ask for the hostname and replace all instances of "anacreon"
read -p "Enter your hostname: " hostname
cp -r hosts/anacreon "hosts/$hostname"
grep -rl "anacreon" "hosts/$hostname" | xargs sed -i "s/anacreon/$hostname/g"

# Step 5: Copy the hyprpanel config
echo "Copying ags configs.."
mkdir -p ~/.cache/ags/hyprpanel
cp config/hyprpanel.json ~/.cache/ags/hyprpanel/options.json
echo "Ags configs successfully copied."

# Step 6: Prompt the user for wallpaper repositories
echo "Choose wallpaper repositories to install:"
echo "1) https://github.com/orxngc/walls"
echo "2) https://github.com/orxngc/walls-catppuccin-mocha"
echo "3) Other (enter URL)"
echo "4) None"
echo "Warning: You can only use one wallpaper repository at a time."
read -p "Enter your choice (comma-separated for multiple options): " choice

cd $HOME/Pictures || exit
IFS=',' read -ra ADDR <<< "$choice"
for i in "${ADDR[@]}"; do
    case $i in
        1)
            git clone https://github.com/orxngc/walls
            sed -i "s/walls/walls/g" "$HOME/dots/scripts/walls.nix"
            ;;
        2)
            git clone https://github.com/orxngc/walls-catppuccin-mocha
            sed -i "s/walls/walls-catppuccin-mocha/g" "$HOME/dots/scripts/walls.nix"
            ;;
        3)
            read -p "Enter the URL of the wallpaper repository: " repo_url
            repo_name=$(basename "$repo_url" .git)
            git clone "$repo_url"
            sed -i "s/walls/$repo_name/g" "$HOME/dots/scripts/walls.nix"
            ;;
        4)
            echo "Warning: No wallpaper repository selected. Wallpapers will be broken unless you put images into $username/Pictures/walls."
            ;;
        *)
            echo "Invalid choice: $i"
            ;;
    esac
done

# Step 7: Clone and rename HyprPanel
echo "Cloning Jas-SinghFSU's (huge credit to this guy for his ags setup) HyprPanel.."
cd ~/.config || exit
git clone https://github.com/Jas-SinghFSU/HyprPanel/
mv HyprPanel ags
echo "Successfully cloned HyprPanel."

# Step 8: Generate hardware config
echo "Generating hardware configuration..."
cd $HOME/dots || exit
nixos-generate-config --show-hardware-config > "hosts/$hostname/hardware.nix"
echo "Hardware configuration successfully generated."

# Step 9: Set NIX_CONFIG
export NIX_CONFIG="experimental-features = nix-command flakes"
echo "Enabled flakes."

# Step 10: Ask for git username and email, and replace them in variables.nix
read -p "Enter your git username: " git_username
read -p "Enter your git email: " git_email
sed -i "s/gitUsername = \"orxngc\";/gitUsername = \"$git_username\";/g" "hosts/$hostname/variables.nix"
sed -i "s/gitEmail = \"orangc@proton.me\";/gitEmail = \"$git_email\";/g" "hosts/$hostname/variables.nix"

# Step 11: Rebuild the system with the specified hostname
echo "Rebuilding system..."
sudo nixos-rebuild boot --flake ".#$hostname"
echo "System successfully rebuilt."
echo " IMPORTANT: reboot your system now for the changes to take effect."
echo "Have fun with my dots! —orangc"