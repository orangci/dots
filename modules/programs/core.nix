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
    grimblast # for screenshots
    nurl
    alejandra
    libwebp
    ncftp
    mya # myanimelist owo
    lutgen
    catimg

    # big gui programs
    file-roller
    # transmission_4-gtk # bittorent client
    qimgv # image viewer
    calibre # ebooks
    micro
    pinta
    otpclient
    modrinth-app

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
