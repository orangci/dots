#!/usr/bin/env bash

# Full path to the recording file
output_file="/tmp/$(date +'%B-%d-%H.%M.%S').wav"


arecord -f cd -t wav $output_file
RECORDING_PID=$!
notify-send "Recording Started" "Voice recording has started."

wait $RECORDING_PID

save_location=${yad --file --save --title="Save recording" --text="Save the recording to:" --filename="$(date +'%B %d %H.%M.%S').wav"}
if [ -z "$save_location" ]; then
    notify-send "Voice recording" "Recording canceled."
    rm $output_file
    exit 1
fi

mv $output_file $save_location

notify-send "Screen recording" "Recording saved to $save_location" \
--action="View file in folder"
# notify-send button
if [ "$?" -eq 0 ]; then
    thunar "$(dirname "$save_location")"
fi