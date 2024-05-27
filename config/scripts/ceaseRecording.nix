{pkgs}:
pkgs.writeShellScriptBin "cease-recording" ''
  PID=$(cat /tmp/wf-recorder.pid)
  kill $PID
  TIMESTAMP=$(date +'%b %d %Y - %H.%M')
  mv /tmp/screen_recording.mp4 "$HOME/Videos/snapshots/screen_recording_$TIMESTAMP.mp4"
  rm /tmp/wf-recorder.pid
''
