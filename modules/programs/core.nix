{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];

  environment.systemPackages = with pkgs; [
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = ["rust-src"];
    })
    rustlings
    rust-analyzer
    lxqt.lxqt-policykit
    wl-clipboard
    libnotify
    yad
    grim
    slurp
    wayfreeze
    # begin illogical-impulse deps
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qt5compat
    libqalculate
    tesseract
    colloid-kde
    wlsunset
    # end illogical-impulse deps
    nh
    brightnessctl
    btop
    unzip
    zip
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
    onefetch
    trashy
    ffmpeg
    imagemagick
    nix-prefetch
    # open-interpreter
    python313
    uv
    ruff
    virtualenv
    wev
    jq
    black
    yt-dlp
    wl-screenrec
    alejandra
    libwebp
    ncftp
    mya # myanimelist owo
    lutgen
    catimg
    tailwindcss
    gcc
    nodejs
    hyprpicker
    temurin-jre-bin
    micro

    # big gui programs
    # file-roller # BIG 1.1GB
    # transmission_4-gtk # bittorent client
    kdePackages.gwenview # image viewer BIG 1.3GB
    calibre # ebooks BIG 2.1GB
    obsidian # BIG 1.8GB
    typst
    pinta # half a GB
    otpclient # half a GB
    wvkbd

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
