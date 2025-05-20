{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    wl-clipboard
    libnotify
    yad
    # begin illogical-impulse deps
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qt5compat
    libqalculate
    colloid-kde
    wlsunset
    # end illogical-impulse deps
    nh
    btop
    lshw
    gnumake # gnumake
    rink
    swww
    killall
    tree
    time
    dig
    nix-output-monitor
    diskus
    tokei
    sd
    trashy
    ffmpeg
    imagemagick
    nix-prefetch
    # open-interpreter
    wev
    jq
    yt-dlp
    wl-screenrec
    alejandra
    libwebp
    ncftp
    lutgen
    catimg
    gcc
    nodejs
    temurin-jre-bin
    hyprpicker
    micro

    # big gui programs
    # transmission_4-gtk # bittorent client
    calibre # ebooks BIG 2.1GB
    obsidian # BIG 1.8GB
    typst
    pinta # half a GB
    otpclient # half a GB
    wvkbd
  ];
}
