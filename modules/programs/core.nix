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
    eza
    lshw
    gnumake # gnumake
    rink
    swww
    swappy
    swaynotificationcenter
    wget
    killall
    git
    fzf
    wlogout
    tree
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    ripgrep
    time
    dig
    nix-output-monitor
    trashy
    cliphist
    ffmpeg
    bat
    lutgen
    fd
    imagemagick
    mya # myanimelist owo
    nix-prefetch
    # open-interpreter
    hyprlock
    pinta
    python3
    wev
    jq
    figlet
    wf-recorder
    rofi-wayland
    grimblast # for screenshots
    nurl
    libwebp
    image_optim
    alejandra

    # big gui programs
    file-roller
    # transmission_4-gtk # bittorent client
    whatsapp-for-linux
    vscodium
    qimgv # image viewer
    calibre # ebooks
    otpclient
    filezilla
    zoom-us

    # fun stuffs
    cmatrix
    lolcat
    fastfetch
    tty-clock
    nitch
    uwuify
    owofetch
    catimg
    ipfetch
  ];
}
