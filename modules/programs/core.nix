{
  config,
  pkgs,
  host,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    wl-clipboard
    libnotify
    yad
    grim
    slurp
    wayfreeze
    nh
    brightnessctl
    btop
    unzip
    unrar
    zip
    lshw
    gnumake # gnumake
    rink
    swww
    killall
    tree
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    time
    dig
    nix-output-monitor
    trashy
    ffmpeg
    imagemagick
    nix-prefetch
    # open-interpreter
    python3
    virtualenv
    wev
    jq
    yt-dlp
    wf-recorder
    alejandra
    libwebp
    ncftp
    mya # myanimelist owo
    lutgen
    catimg
    hyprpicker

    # big gui programs
    # file-roller # BIG 1.1GB
    # transmission_4-gtk # bittorent client
    gwenview # image viewer BIG 1.3GB
    # calibre # ebooks BIG 2.1GB
    micro
    osu-lazer # BIG 1GB
    pinta # half a GB
    otpclient # half a GB

    # fun stuffs
    cmatrix
    lolcat
    tty-clock
    kittysay
    nitch
    uwuify
    owofetch
    ipfetch
  ];
}
