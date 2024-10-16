{pkgs}:
pkgs.writeShellScriptBin "wall-select" ''
  # Predefined folders
  folders=(
      "$HOME/media/walls"
      "$HOME/media/walls-catppuccin-mocha"
      "anibg"
  )

  # Default folder for the --fast option
  default_folder="$HOME/media/walls"

  # Check if the --fast option is provided
  if [ "$1" == "--fast" ]; then
      selected_folder="$default_folder"
  else
      # Convert array to rofi string
      folder_string=$(printf '%s\n' "''${folders[@]}")

      # Select folder using rofi
      selected_folder=$(echo -e "$folder_string" | rofi -dmenu -p "Select Folder:")
  fi

  # Check if a folder was selected or default folder is used
  if [ -z "$selected_folder" ]; then
      echo "No folder selected."
      exit 1
  fi

  # Special case: when 'anibg' is selected
  if [ "$selected_folder" == "anibg" ]; then
      # Fetch a random anime wallpaper using Wallhaven API
      random_image_url=$(curl -s "https://wallhaven.cc/api/v1/search?q=anime+girls&categories=010&purity=100&sorting=random&atleast=1920x1080" | jq -r '.data[0].path')

      if [ -z "$random_image_url" ]; then
          echo "Failed to fetch an anime wallpaper."
          exit 1
      fi

      # Download the image to a temporary location
      temp_image="/tmp/random_anime_wallpaper.jpg"
      curl -s "$random_image_url" -o "$temp_image"

      # Set the downloaded image as the wallpaper using swww
      swww img "$temp_image" --transition-type random --transition-fps 60
      echo "Anime wallpaper set from $random_image_url"
      echo "\$WALLPAPER=$temp_image" > /tmp/.current_wallpaper_path_hyprlock
      echo "$temp_image" > /tmp/.current_wallpaper_path
      exit 0
  fi

  # Get image files in the selected folder
  images=($(ls "$selected_folder" | grep -E '\.(jpg|jpeg|png|bmp|gif)$' | sort))

  # Check if there are any images in the folder
  if [ ''${#images[@]} -eq 0 ]; then
      echo "No images found in the selected folder."
      exit 1
  fi

  # Shuffle the array of images
  shuffled_images=($(shuf -e "''${images[@]}"))

  # Generate the rofi image list with previews
  image_list=""
  for i in "''${!shuffled_images[@]}"; do
      image="''${shuffled_images[$i]}"
      filename=$(basename "$image")
      filename_without_extension=$(basename "$image" | sed 's/\.[^.]*$//')
      image_path=$(realpath "$selected_folder/$filename")  # Use realpath to get the absolute path
      image_list+="$filename_without_extension\0icon\x1f$image_path\n"
  done

  # Use rofi to select image with previews and get the selected entry
  selected_entry=$(echo -e "$image_list" | rofi -dmenu -markup-rows -p "Select Image:" -theme selector-big.rasi -i -selected-row 0 -format "i" -preview "qimgv {1}")

  # Check if an image was selected
  if [ -z "$selected_entry" ]; then
      echo "No valid image selected."
      exit 1
  fi

  # The selected_entry is directly the index
  selected_index=$selected_entry

  # Get the full path of the selected image
  selected_image_file="''${shuffled_images[$selected_index]}"

  # Set the selected image as the wallpaper using swww
  if [ -n "$selected_image_file" ]; then
      swww img "$selected_folder/$selected_image_file" --transition-type random --transition-fps 60
      echo "Wallpaper set to $selected_folder/$selected_image_file"
      echo "\$WALLPAPER=$selected_folder/$selected_image_file" > /tmp/.current_wallpaper_path_hyprlock
      echo "$selected_folder/$selected_image_file" > /tmp/.current_wallpaper_path
  else
      echo "Image not found."
      exit 1
  fi
''
