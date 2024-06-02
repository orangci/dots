{pkgs}:
pkgs.writeShellScriptBin "walls-update" ''
  cd $HOME/Pictures
  # Variables
  image_folder="walls"
  output_file="walls/README.md"

  # Create or clear the output file
  cat $image_folder/README-without-preview.md > $output_file
  echo "" >> $output_file

  # Add table header
  echo "| Column 1 | Column 2 | Column 3 | Column 4 |" >> $output_file
  echo "|---------|---------|---------|---------|" >> $output_file

  # Initialize a counter for images
  counter=0

  # Initialize a row variable
  row=""

  # Loop through all image files in the folder
  shopt -s nullglob
  for image in "$image_folder"/*.{jpg,jpeg,png,gif}; do
    if [[ -f $image ]]; then
      # Extract the file name from the path
      filename=$(basename "$image")
      # Construct the URL
      url="https://raw.githubusercontent.com/orxngc/walls/main/$filename"
      # Append the markdown for the image to the row
      row="$row| ![${filename}](${url}) "
      # Increment the counter
      ((counter++))
      # If counter is 4, reset the counter and append the row to the output file
      if [[ $counter -eq 4 ]]; then
        echo "$row|" >> $output_file
        row=""
        counter=0
      fi
    fi
  done

  # If there are remaining images in the row, fill the rest of the row with empty cells
  if [[ $counter -ne 0 ]]; then
    while [[ $counter -lt 4 ]]; do
      row="$row| "
      ((counter++))
    done
    echo "$row|" >> $output_file
  fi

  echo "Markdown file '$output_file' generated successfully."
  cd $image_folder
  git stage *
  git commit -m "update README previews"
  git push


  # Catppuccin
  # Variables
  cd $HOME/Pictures
  image_folder="walls-catppuccin-mocha"
  output_file="walls-catppuccin-mocha/README.md"

  cat $image_folder/README-without-preview.md > $output_file
  echo "" >> $output_file
  # Add table header
  echo "| Column 1 | Column 2 | Column 3 | Column 4 |" >> $output_file
  echo "|---------|---------|---------|---------|" >> $output_file

  # Initialize a counter for images
  counter=0

  # Initialize a row variable
  row=""

  # Loop through all image files in the folder
  shopt -s nullglob
  for image in "$image_folder"/*.{jpg,jpeg,png,gif}; do
    if [[ -f $image ]]; then
      # Extract the file name from the path
      filename=$(basename "$image")
      # Construct the URL
      url="https://raw.githubusercontent.com/orxngc/walls-catppuccin-mocha/master/$filename"
      # Append the markdown for the image to the row
      row="$row| ![${filename}](${url}) "
      # Increment the counter
      ((counter++))
      # If counter is 4, reset the counter and append the row to the output file
      if [[ $counter -eq 4 ]]; then
        echo "$row|" >> $output_file
        row=""
        counter=0
      fi
    fi
  done

  # If there are remaining images in the row, fill the rest of the row with empty cells
  if [[ $counter -ne 0 ]]; then
    while [[ $counter -lt 4 ]]; do
      row="$row| "
      ((counter++))
    done
    echo "$row|" >> $output_file
  fi

  echo "Markdown file '$output_file' generated successfully."
  cd $image_folder
  git stage *
  git commit -m "update README previews"
  git push
''
