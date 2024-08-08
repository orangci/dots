#!/usr/env/bin bash

# Create a function to handle the start screen recording action
start_screen_recording() {
    $HOME/dots/scripts/screenrec.sh
}

# Create a function to handle the stop screen recording action
stop_screen_recording() {
    pkill wf-recorder
}

# Create a function to handle the start voice recording action
start_voice_recording() {
    $HOME/dots/scripts/micrec.sh
}

# Create a function to handle the stop voice recording action
stop_voice_recording() {
    pkill arecord
}

# Display the YAD dialog with buttons
yad --title="Recording Control" --width=850 --height=50 \
    --center \
    --fixed \
    --button="Start Screen Recording:0" \
    --button="Stop Screen Recording:1" \
    --button="Record Voice:2" \
    --button="Stop Voice Recording:3"

# Get the button clicked by the user
BUTTON=$?

# Perform actions based on the button clicked
case $BUTTON in
    0)
        start_screen_recording
        ;;
    1)
        stop_screen_recording
        ;;
    2)
        start_voice_recording
        ;;
    3)
        stop_voice_recording
        ;;
esac
