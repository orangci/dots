{pkgs}:
pkgs.writeShellScriptBin "wall-select" ''
  # Predefined folders
  folders=(
      "$HOME/media/walls"
      "$HOME/media/walls-catppuccin-mocha"
      "$HOME/media/aniwalls"
  )

  # Default folder for the --fast option
  default_folder="$HOME/media/walls"

  # Function to set wallpaper
  set_wallpaper() {
      local folder="$1"
      local image="$2"
      swww img "$image" --transition-type random --transition-fps 60
      echo "Wallpaper set to $image"
      echo "\$WALLPAPER=$image" >/tmp/.current_wallpaper_path_hyprlock
      echo "$image" >/tmp/.current_wallpaper_path
  }

  # Function to get a random image from a folder
  get_random_image() {
      local folder="$1"
      local images=($(find "$folder" -type f -iregex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\)$' | sort))
      if [ ''${#images[@]} -eq 0 ]; then
          echo "No images found in $folder."
          exit 1
      fi
      echo "''${images[RANDOM % ''${#images[@]}]}"
  }

  # Check if the --fast option is provided
  if [ "$1" == "--fast" ]; then
      selected_folder="$default_folder"
      # Get image files in the selected folder
      images=($(find "$selected_folder" -type f -iregex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\)$' | sort))
      if [ ''${#images[@]} -eq 0 ]; then
          echo "No images found in $selected_folder."
          exit 1
      fi
      # Shuffle the array of images
      shuffled_images=($(shuf -e "''${images[@]}"))
      # Generate the rofi image list with previews
      image_list=""
      for image in "''${shuffled_images[@]}"; do
          filename=$(basename "$image")
          filename_without_extension="''${filename%.*}"
          image_list+="$filename_without_extension\0icon\x1f$image\n"
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
      # Set the selected image as the wallpaper
      set_wallpaper "$selected_folder" "$selected_image_file"
  else
      # Convert array to folder names
      folder_names=("''${folders[@]##*/}")
      # Select folder using rofi
      selected_folder_name=$(printf '%s\n' "''${folder_names[@]}" | rofi -dmenu -p "Select Folder:")
      # Check if a folder was selected
      if [ -z "$selected_folder_name" ]; then
          echo "No folder selected."
          exit 1
      fi
      # Map the selected folder name back to its full path
      for folder in "''${folders[@]}"; do
          if [ "''${folder##*/}" == "$selected_folder_name" ]; then
              selected_folder="$folder"
              break
          fi
      done
      # Get a random image from the selected folder
      selected_image=$(get_random_image "$selected_folder")
      # Set the selected image as the wallpaper
      set_wallpaper "$selected_folder" "$selected_image"
  fi
''
