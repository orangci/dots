{
  config,
  pkgs,
  username,
  host,
  ...
}: let
  inherit (import ./variables.nix) gitUsername gitEmail;
in {
  home = {
    # Home Manager Settings
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
    file = {
      ".local/share/fonts" = {
        source = ../../config/fonts;
        recursive = true;
      };
      ".config/wlogout" = {
        source = ../../config/wlogout;
        recursive = true;
      };
      ".config/starship.toml".source = ../../config/starship.toml;
      ".face.icon".source = ../../config/face.png;
      ".config/Vencord/themes/orangetweaks.css".source = ../../config/Configs/vencordthemes/orangetweaks.css;
      ".config/Vencord/themes/catppuccin.css".source = ../../config/Configs/vencordthemes/catppuccin.css;
      ".config/rofi/rofi-prism.sh".source = ../../scripts/rofi-prism.sh;
      ".config/swappy/config".text = ''
        [Default]
        save_dir=/home/${username}/Pictures/Screenshots
        save_filename_format=swappy-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=JetBrainsMono NFM
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
    };

    # Scripts
    packages = [
      (import ../../scripts/squirtle.nix {inherit pkgs;})
      (import ../../scripts/rofi-launcher.nix {inherit pkgs;})
      (import ../../scripts/rofi-prism-exec.nix {inherit pkgs;})
      (import ../../scripts/walls.nix {inherit pkgs;})
      (import ../../scripts/nvidia-offload.nix {inherit pkgs;})
      (import ../../scripts/web-search.nix {inherit pkgs;})
      (import ../../scripts/screenshootin.nix {inherit pkgs;})
      (import ../../scripts/logout-exit.nix {inherit pkgs;})
    ];
  };

  # Import Program Configurations
  imports = [
    ../../config/hyprland.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/rofi-styles
    ../../config/fastfetch.nix
    # ../../config/firefox.nix
    ../../config/hyprlock.nix
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Styling Options
  stylix = {
    targets = {
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
    };
  };

  # Theme GTK
  gtk = {
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme = "gtk3";
  };

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    gh.enable = true;
    firefox.enable = true;
    mpv = {
      enable = true;
      scripts = [
        pkgs.mpvScripts.mpris
        pkgs.mpvScripts.uosc
        pkgs.mpvScripts.videoclip
        pkgs.mpvScripts.mpv-cheatsheet
      ];
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
        if [ -f /tmp/.current_wallpaper_path ]; then
          export WALLPAPER=$(cat /tmp/.current_wallpaper_path)
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/dots";
        frr = "nh os switch --hostname ${host} /home/${username}/dots;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot;notify-send Rebuilt;exit";
        flake-update = "nh os switch --hostname ${host} --update /home/${username}/dots";
        gcnix = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lal = "lsd -al";
        qq = "clear";
        cat = "bat";
        tr = "trash";
        ".." = "cd ..";
        neofetch = "fastfetch";
        gcrec = "rm -rf ~/Videos/snapshots/*";
        find = "fd";
        ztop = "zfxtop";
        spinmal = "bash $HOME/Documents/spinPTW.sh";
        ga = "git add .";
        cm = "git commit -am --verbose";
        push = "git push";
      };
    };
    home-manager.enable = true;
    hyprlock.enable = true;
  };
}
