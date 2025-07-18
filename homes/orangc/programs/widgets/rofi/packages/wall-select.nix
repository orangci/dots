{ pkgs }:
pkgs.writeShellScriptBin "wall-select" ''
  # Predefined folders
  folders=(
      "$HOME/media/walls"
      "$HOME/media/walls-catppuccin-mocha"
      "$HOME/media/aniwalls"
  )

  # Function to set wallpaper
  set_wallpaper() {
      local image="$1"
      swww img "$image" --transition-type random --transition-fps 60 --transition-duration 1
      echo "Wallpaper set to $image"
      echo "\$WALLPAPER=$image" >/tmp/.current_wallpaper_path_hyprlock
      echo "$image" >/tmp/.current_wallpaper_path
      sleep 1
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

  # Function to display image selection menu with previews
    select_image_with_preview() {
        local folder="$1"
        # Find image files in the folder
        local images=($(find "$folder" -type f -iregex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\)$'))
        if [ ''${#images[@]} -eq 0 ]; then
            echo "No images found in $folder."
            exit 1
        fi

        # Shuffle the array of images
        local shuffled_images=($(shuf -e "''${images[@]}"))

        # Generate the Rofi image list with previews
        local image_list=""
        for image in "''${shuffled_images[@]}"; do
            local filename=$(basename "$image")
            local filename_without_extension="''${filename%.*}"
            image_list+="$filename_without_extension\0icon\x1f$image\n"
        done

        # Use Rofi to select an image with previews and get the selected entry
        local selected_entry=$(echo -e "$image_list" | rofi -dmenu -markup-rows -p "Select Image:" -theme selector-big.rasi -i -selected-row 0 -format "i" -preview "qimgv {1}")

        # Check if an image was selected
        if [ -z "$selected_entry" ]; then
            echo "No valid image selected."
            exit 1
        fi

        # The selected_entry is directly the index
        local selected_image_file="''${shuffled_images[$selected_entry]}"

        echo "$selected_image_file"
    }

  # Function to select folder using rofi
  select_folder() {
      local folder_names=("''${folders[@]##*/}")
      local selected_folder_name=$(printf '%s\n' "''${folder_names[@]}" | rofi -dmenu -p "Select Folder:")
      if [ -z "$selected_folder_name" ]; then
          echo "No folder selected."
          exit 1
      fi

      # Map the selected folder name back to its full path
      for folder in "''${folders[@]}"; do
          if [ "''${folder##*/}" == "$selected_folder_name" ]; then
              echo "$folder"
              return
          fi
      done

      echo "Selected folder not found."
      exit 1
  }

  # Main script logic
  if [ "$1" == "--fast" ]; then
      selected_folder=$(select_folder)
      selected_image=$(get_random_image "$selected_folder")
      set_wallpaper "$selected_image"
  else
      selected_folder=$(select_folder)
      selected_image=$(select_image_with_preview "$selected_folder")
      set_wallpaper "$selected_image"
  fi
''
