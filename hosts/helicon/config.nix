{ config
, pkgs
, host
, username
, options
, lib
, inputs
, ...
}: {
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
    ../../modules/printing.nix
    ../../modules/bluetooth.nix
    ../../modules/sound.nix
    # ../../modules/android.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader = {
      # Bootloader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  # Styling Options
  stylix = {
    enable = true;
    image = ../../files/face.png;
    base16Scheme = {
      base00 = "1e1e2e";
      base01 = "181825";
      base02 = "313244";
      base03 = "45475a";
      base04 = "585b70";
      base05 = "cdd6f4";
      base06 = "f5e0dc";
      base07 = "b4befe";
      base08 = "f38ba8";
      base09 = "fab387";
      base0A = "f9e2af";
      base0B = "a6e3a1";
      base0C = "94e2d5";
      base0D = "89b4fa";
      base0E = "cba6f7";
      base0F = "f2cdcd";
    };
    polarity = "dark";
    cursor = {
      package = pkgs.oreo-cursors-plus;
      name = "oreo_spark_orange_cursors";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.raleway;
        name = "Raleway";
      };
      serif = {
        package = pkgs.merriweather;
        name = "Merriweather";
      };
      sizes = {
        applications = 12;
        terminal = 16;
        desktop = 12;
        popups = 12;
      };
    };
  };

  # Extra Module Options
  drivers = {
    amdgpu.enable = false;
    nvidia.enable = false;
    nvidia-prime = {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
    intel.enable = true;
  };
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  networking = {
    # Enable networking
    networkmanager.enable = true;
    hostName = "${host}";
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
  };
  environment.etc = {
    "resolv.conf".text = "nameserver 1.1.1.1\n";
  };

  # Set your time zone.
  services.automatic-timezoned.enable = true;
  # time.timeZone = "Asia/Riyadh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
    hyprlock.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    java.enable = true;
    noisetorch.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = false;
      # gamescopeSession.enable = true;
      # remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };
  nixpkgs.config.packageOverrides = pkgs: {
    xfce =
      pkgs.xfce
      // {
        inherit (pkgs) gvfs;
      };
  };
  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; let
    sddm-themes = pkgs.callPackage ../../config/sddm.nix { };
  in
  [
    # sddm-themes.sugar-dark
    # sddm-themes.tokyo-night
    sddm-themes.astronaut
    lxqt.lxqt-policykit
    ydotool
    wl-clipboard
    libnotify
    appimage-run
    networkmanagerapplet
    yad
    grim
    slurp
    playerctl
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
    pavucontrol
    tree
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    ripgrep
    time
    dig
    yt-dlp
    traceroute
    speedtest-cli
    trashy
    # glow # markdown viwer
    cliphist
    ffmpeg
    bat
    lutgen
    fd
    imagemagick
    nwg-look # gtk settings
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
    xfce.tumbler # for image thumbnails in thunar
    arrpc
    rofi-wayland
    grimblast # for screenshots
    nurl
    alejandra

    # big gui programs
    file-roller
    transmission_4-gtk # bittorent client
    whatsapp-for-linux
    vscodium
    qimgv # image viewer
    calibre # ebooks
    otpclient
    google-chrome
    prismlauncher
    filezilla
    zoom-us
    (pkgs.discord.override {
      withOpenASAR = true;
      withTTS = true;
      withVencord = true;
    })
    # armcord

    # fun stuffs
    cmatrix
    lolcat
    fastfetch
    tty-clock
    nitch
    cava
    uwuify
    owofetch
    catimg
    ipfetch
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      symbola
      ubuntu-sans
      merriweather-sans
      merriweather
      material-icons
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  # Services to start
  services = {
    displayManager.sddm = {
      enable = true; # Enable SDDM.
      wayland.enable = true;
      theme = "astronaut";
    };
    upower.enable = true;
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    smartd.enable = true; # auto monitor drives health
    libinput.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  hardware = {
    logitech.wireless.enable = true;
    graphics.enable = true;
  };

  security = {
    # Security / Polkit
    rtkit.enable = true;
    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      })
    '';
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
