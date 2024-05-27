{
  pkgs,
  config,
  username,
  host,
  ...
}: let
  inherit
    (import ../../hosts/${host}/options.nix)
    browser
    wallpaperDir
    wallpaperGit
    flakeDir
    ;
in {
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}"
    libvirt
    swww
    grim
    slurp
    gnome.file-roller
    wf-recorder
    swaynotificationcenter
    rofi-wayland
    arrpc
    transmission-gtk
    wl-clipboard
    krita
    ripgrep
    obs-studio
    dig
    time
    nitch
    rustup
    pavucontrol
    tree
    openjdk
    protonup-qt
    font-awesome
    swayidle
    fastfetch
    neovide
    (vesktop.override {
      withSystemVencord = false;
    })
    tldr
    vscodium
    youtube-dl
    traceroute
    alejandra
    cava
    speedtest-cli
    cmus
    trashy
    glow
    cliphist
    ffmpeg
    bat
    prismlauncher
    filezilla
    zoom-us
    lutgen
    fd
    imagemagick
    catimg
    otpclient
    mpv
    ripgrep
    nwg-look
    mya
    zip
    qimgv
    hyprlock
    betterbird
    zfxtop
    protonvpn-gui
    wttrbar
    google-chrome
    obsidian
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
    # Import Scripts
    (import ./../scripts/emopicker9000.nix {inherit pkgs;})
    (import ./../scripts/task-waybar.nix {inherit pkgs;})
    (import ./../scripts/squirtle.nix {inherit pkgs;})
    (import ./../scripts/wallsetter.nix {
      inherit pkgs;
      inherit wallpaperDir;
      inherit username;
      inherit wallpaperGit;
    })
    (import ./../scripts/themechange.nix {
      inherit pkgs;
      inherit flakeDir;
      inherit host;
    })
    (import ./../scripts/ceaseRecording.nix {inherit pkgs;})
    (import ./../scripts/startRecording.nix {inherit pkgs;})
    (import ./../scripts/clipRecording.nix {inherit pkgs;})
    (import ./../scripts/theme-selector.nix {inherit pkgs;})
    (import ./../scripts/nvidia-offload.nix {inherit pkgs;})
    (import ./../scripts/web-search.nix {inherit pkgs;})
    (import ./../scripts/rofi-launcher.nix {inherit pkgs;})
    (import ./../scripts/rofi-powermenu.nix {inherit pkgs;})
    (import ./../scripts/screenshootin.nix {inherit pkgs;})
    (import ./../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];
  programs.gh.enable = true;
}
