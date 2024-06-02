{ pkgs }:
pkgs.writeShellScriptBin "clip-recording" ''
  PID=$(cat /tmp/wf-recorder.pid)
  kill $PID
  TIMESTAMP=$(date +'%b %d %Y - %H.%M')
  OUTPUT_DIR=$HOME/Videos/snapshots
  mkdir -p "$OUTPUT_DIR"
  RECORDED_FILE="/tmp/screen_recording.mp4"
  TRIMMED_FILE="/tmp/screen_recording_trimmed.mp4"
  ffmpeg -sseof -60 -i "$RECORDED_FILE" -c copy "$TRIMMED_FILE"
  mv "$TRIMMED_FILE" "$OUTPUT_DIR/screen_recording_$TIMESTAMP.mp4"
  rm "$RECORDED_FILE"
  rm /tmp/wf-recorder.pid
''
