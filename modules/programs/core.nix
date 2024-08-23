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
    lutgen
    imagemagick
    mya # myanimelist owo
    nix-prefetch
    # open-interpreter
    pinta
    python3
    wev
    jq
    figlet
    wf-recorder
    grimblast # for screenshots
    nurl
    libwebp
    image_optim
    alejandra

    # big gui programs
    file-roller
    # transmission_4-gtk # bittorent client
    whatsapp-for-linux
    qimgv # image viewer
    calibre # ebooks
    otpclient
    filezilla
    zoom-us

    # fun stuffs
    cmatrix
    lolcat
    tty-clock
    nitch
    uwuify
    owofetch
    catimg
    ipfetch
  ];
}
