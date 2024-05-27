{pkgs}:
pkgs.writeShellScriptBin "start-recording" ''
  wf-recorder -f /tmp/screen_recording.mp4 &
  echo $! > /tmp/wf-recorder.pid
''
