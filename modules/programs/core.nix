{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    libnotify
    nh
    nix-output-monitor
    deadnix
    micro

    hyprpicker
    calibre # ebooks BIG 2.1GB
    obsidian # BIG 1.8GB
    pinta # half a GB
    otpclient # half a GB
  ];
}
