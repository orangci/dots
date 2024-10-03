#!/usr/bin/env bash

# check if the user is on NixOS
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


# clone orxngc/dots in $HOME
cd $HOME || exit
echo "Cloning repository..."
git clone https://github.com/orxngc/dots
echo "orxngc/dots cloned successfully."
cd $HOME/dots
# Ask the user for their username & hostname
read -p "Enter your username: " username
sed -i 's/\(username = "\)[^"]*\(".*\)/\1'$username'\2/' flake.nix
read -p "Enter your hostname: " hostname
cp -r $HOME/dots/hosts/anacreon "$HOME/dots/hosts/$hostname"
sed -i 's/\(host = "\)[^"]*\(".*\)/\1'$hostname'\2/' flake.nix

# Copy the hyprpanel config
cp $HOME/dots/files/hyprpanel.json $HOME/.cache/ags/hyprpanel/options.json

# Prompt the user for wallpaper repositories
echo "Choose wallpaper repositories to install:"
echo "1) https://github.com/orxngc/walls"
echo "2) https://github.com/orxngc/walls-catppuccin-mocha"
echo "3) Other (enter URL)"
echo "4) None"
echo "Warning: You can only use one wallpaper repository at a time."
read -p "Enter your choice (comma-separated for multiple options): " choice
mkdir $HOME/media
cd $HOME/media || exit
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
            echo "Warning: No wallpaper repository selected. Wallpapers will be broken unless you put images into $username/media/walls."
            ;;
        *)
            echo "Invalid choice: $i"
            ;;
    esac
done

cd $HOME/dots
# Generate hardware config
echo "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > "$HOME/dots/hosts/$hostname/hardware.nix"
echo "Hardware configuration successfully generated."

# Set NIX_CONFIG
export NIX_CONFIG="experimental-features = nix-command flakes"
echo "Enabled flakes."

# Ask for git username and email, and replace them in variables.nix
read -p "Enter your git username: " git_username
read -p "Enter your git email: " git_email
sed -i "s/gitUsername = \"orxngc\";/gitUsername = \"$git_username\";/g" "$HOME/dots/hm-modules/core/boilerplate.nix"
sed -i "s/gitEmail = \"orangc@proton.me\";/gitEmail = \"$git_email\";/g" "$HOME/dots/hm-modules/core/boilerplate.nix"

# GitHub stashing
git add .
git commit -m "Save changes"
# Rebuild the system with the specified hostname
echo "Rebuilding system..."
sudo nixos-rebuild boot --flake ".#$hostname" --show-trace
home-manager switch --flake $HOME/dots
echo "System successfully rebuilt."
echo " IMPORTANT: reboot your system now for the changes to take effect."
echo "Have fun with my dots! —orangc"
