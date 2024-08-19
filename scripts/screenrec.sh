#!/usr/bin/env bash

# Generate a filename based on the current date and time
output_file="/tmp/$(date +'%B-%d-%H.%M.%S').mov"

# Define the audio sink (adjust this to match your system's default audio sink)
audio_sink="alsa_output.pci-0000_00_1b.0.analog-stereo.monitor"

# Start fullscreen recording with system audio
wf-recorder -f "$output_file" --audio="$audio_sink" &
recorder_pid=$!

# Send a notification that recording is starting
notify-send "Screen Recording" "Recording started..."

# Wait for wf-recorder to finish
wait $recorder_pid

# Check if wf-recorder ran successfully
if [ ! -f "$output_file" ]; then
    notify-send "Screen Recording" "Recording failed: Output file not created."
    exit 1
fi

# Ask the user where to save the recording using yad
save_location=$(yad --file --save --title="Save Recording As" --filename="$HOME/media/vids/$(date +'%B %d %H.%M.%S').mov")

# Check if the user canceled the save location selection
if [ -z "$save_location" ]; then
    notify-send "Screen Recording" "Recording canceled."
    rm $output_file
    exit 1
fi

# Move the temporary file to the chosen location
mv "$output_file" "$save_location"

# Send a notification that recording has finished
notify-send "Screen Recording" "Recording saved to $save_location" \
    --action="View file in folder"

# Handle the action when clicked
if [ "$?" -eq 0 ]; then
    thunar "$(dirname "$save_location")"
fi
