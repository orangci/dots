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
    wget
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
    wev
    jq
    yt-dlp
    figlet
    wf-recorder
    grimblast # for screenshots
    nurl
    alejandra
    libwebp
    image_optim
    mya # myanimelist owo
    lutgen

    # big gui programs
    file-roller
    # transmission_4-gtk # bittorent client
    whatsapp-for-linux
    qimgv # image viewer
    calibre # ebooks
    micro
    pinta
    otpclient
    filezilla
    zoom-us

    # fun stuffs
    cmatrix
    lolcat
    tty-clock
    kittysay
    nitch
    uwuify
    owofetch
    catimg
    ipfetch
  ];
}
