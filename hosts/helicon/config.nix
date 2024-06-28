{
  config,
  pkgs,
  host,
  username,
  inputs,
  options,
  ...
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
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
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
    image = ../../config/face.png;
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
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
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
    amdgpu.enable = true;
    nvidia.enable = false;
    nvidia-prime = {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
    intel.enable = false;
  };
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  networking = {
    # Enable networking
    networkmanager.enable = true;
    hostName = "${host}";
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  };

  # Set your time zone.
  # services.automatic-timezoned.enable = true;
  time.timeZone = "America/New_York";

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
      xwayland.enable = true;
    };
    # firefox.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    noisetorch.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    steam = {
      enable = false;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
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

  environment.systemPackages = with pkgs; [
    wget
    killall
    git
    cmatrix
    lolcat
    fastfetch
    htop
    btop
    lxqt.lxqt-policykit
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    wl-clipboard
    pciutils
    whatsapp-for-linux
    socat
    ripgrep
    lsd
    lshw
    pkg-config
    meson
    gnumake
    ninja
    brightnessctl
    swappy
    appimage-run
    networkmanagerapplet
    yad
    playerctl
    nh
    nixfmt-rfc-style
    swww
    grim
    slurp
    gnome.file-roller
    swaynotificationcenter
    transmission-gtk
    mpv
    gimp
    hakuneko
    obs-studio
    rustup
    pavucontrol
    tree
    font-awesome
    pkgs.libsForQt5.qt5.qtgraphicaleffects
    ripgrep
    time
    dig
    nitch
    openjdk
    vscodium
    yt-dlp
    calibre # ebooks
    traceroute
    cava
    speedtest-cli
    cmus
    trashy
    glow # markdown viwer
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
    mpv # media player
    nwg-look # gtk settings
    mya # myanimelist owo
    nix-prefetch
    zip
    qimgv # image viewer
    hyprlock
    protonvpn-gui
    wttrbar # for waybar
    google-chrome
    zfxtop
    rofi-wayland
    bemoji # for emoji picker
    wtype # for emoji picker
    python3
    uwuify
    wev
    owofetch
    jq
    vencord
    greetd.tuigreet
    xfce.tumbler # for image thumbnails in thunar
    arrpc
    grimblast # for screenshots
    nurl
    (pkgs.discord.override {
      withOpenASAR = true;
      withTTS = true;
      withVencord = true;
    })
    armcord
    inputs.nixvim.packages.${pkgs.system}.default
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      symbola
      material-icons
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };

  # environment.variables = {
  # };

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
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          # Wayland Desktop Manager is installed only for user ryan via home-manager!
          user = "${username}";
          # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
          # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
          # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };

    libinput.enable = true;
    gvfs.enable = true;
    samba.enable = true;
    openssh.enable = true;
    printing.enable = true;
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
    pulseaudio.enable = false;
    # Bluetooth Support
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    # OpenGL
    opengl = {
      enable = true;
    };
  };
  # Enable sound with pipewire.
  sound.enable = true;
  services.blueman.enable = true;
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
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
  system.stateVersion = "23.11"; # Did you read the comment?
}
