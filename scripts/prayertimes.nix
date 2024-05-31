{pkgs}:
pkgs.writeShellScriptBin "prayer-times-daemon" ''
  #!/bin/bash

  # Define your location (latitude and longitude)
  LATITUDE=24.7136
  LONGITUDE=46.6753
  METHOD=4 # Islamic Society of North America (ISNA) calculation method

  # Fetch prayer times from Aladhan API
  response=$(curl -s "http://api.aladhan.com/v1/timings?latitude=$LATITUDE&longitude=$LONGITUDE&method=$METHOD")

  # Extract prayer times using jq
  fajr=$(echo $response | jq -r '.data.timings.Fajr')
  dhuhr=$(echo $response | jq -r '.data.timings.Dhuhr')
  maghrib=$(echo $response | jq -r '.data.timings.Maghrib')
  isha=$(echo $response | jq -r '.data.timings.Isha')

  # Schedule notifications for each prayer time
  notify-send "Prayer Times" "Fajr: $fajr"
  notify-send "Prayer Times" "Dhuhr: $dhuhr"
  notify-send "Prayer Times" "Maghrib: $maghrib"
  notify-send "Prayer Times" "Isha: $isha"

  # Function to schedule notifications
  schedule_notification() {
      local prayer_time=$1
      local prayer_name=$2

      # Convert prayer time to 24-hour format
      prayer_hour=$(echo $prayer_time | cut -d':' -f1)
      prayer_minute=$(echo $prayer_time | cut -d':' -f2)

      # Calculate the number of seconds from now until the prayer time
      now=$(date +%s)
      prayer_timestamp=$(date -d "today $prayer_hour:$prayer_minute" +%s)
      if [ $prayer_timestamp -lt $now ]; then
          # If the prayer time has already passed today, schedule for tomorrow
          prayer_timestamp=$(date -d "tomorrow $prayer_hour:$prayer_minute" +%s)
      fi
      delay=$((prayer_timestamp - now))

      # Schedule the notification
      (sleep $delay && notify-send "Prayer Time" "$prayer_name: $prayer_time") &
  }

  # Schedule notifications for each prayer time
  schedule_notification "$fajr" "Fajr"
  schedule_notification "$dhuhr" "Dhuhr"
  schedule_notification "$maghrib" "Maghrib"
  schedule_notification "$isha" "Isha"

''
