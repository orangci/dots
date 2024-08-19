{
  pkgs,
  username,
  host,
  inputs,
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
      ".face.icon".source = ../../files/face.png;
      ".config/Vencord/themes/orangetweaks.css".source = ../../files/vencordthemes/orangetweaks.css;
      ".config/Vencord/themes/catppuccin.css".source = ../../files/vencordthemes/catppuccin.css;
      ".config/mpv/input.conf".text = ''
        alt+s playlist-shuffle
      '';
      ".config/swappy/config".text = ''
        [Default]
        save_dir=/home/${username}/media/screenshots
        save_filename_format=%M %d-%H.%M.%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=Raleway
        paint_mode=brush
        early_exit=true
        fill_shape=false
      '';
    };

    packages = [
      (import ../../scripts/rofi/calc.nix {inherit pkgs;})
      (import ../../scripts/logout-exit.nix {inherit pkgs;})
      inputs.nixvim.packages.${pkgs.system}.default
    ];
  };

  # Import Program Configurations
  imports = [
    ../../config/hyprland.nix
    ../../config/swaync.nix
    # ../../config/waybar
    ../../config/rofi-styles
    ../../config/ags.nix
    ../../config/fastfetch.nix
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
      kde.enable = false;
    };
  };

  # Theme GTK
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
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
    platformTheme.name = "gtk3";
  };

  services = {
    hypridle = {
      enable = true;
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
      scripts = [pkgs.mpvScripts.mpris];
    };
    starship.enable = true;
    kitty = {
      enable = true;
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
        fr = "sudo echo Shikanoko Nokonoko Koshitantan;nh os switch --hostname ${host} /home/${username}/dots";
        frfr = "sudo echo Shikanoko Nokonoko Koshitantan;nh os switch --hostname ${host} /home/${username}/dots;notify-send Rebuilt;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot;notify-send Cleaned;exit";
        flake-update = "sudo echo Shikanoko Nokonoko Koshitantan;nh os switch --hostname ${host} --update /home/${username}/dots";
        gcnix = "sudo echo Shikanoko Nokonoko Koshitantan;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "eza --icons=auto";
        lh = "eza -a --icons=auto";
        l = "eza -l --icons=auto";
        la = "eza -al --icons=auto";
        qq = "clear";
        cat = "bat";
        tr = "trash";
        ".." = "cd ..";
        neofetch = "fastfetch";
        find = "fd";
        spinmal = "bash $HOME/docs/spinPTW.sh";
        ga = "git add .";
        push = "git push";
        top = "btop";
        mktar = "tar -czvf";
        extar = "tar -xzvf";
        list-big-pkgs = "nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n 30";
        list-pkgs = "nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq";
      };
    };
    home-manager.enable = true;
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["firefox.desktop"];
      "image/*" = ["qimgv.desktop"];
      "video/*" = ["mpv.desktop"];
      "audio/*" = ["mpv.desktop"];
      "text/*" = ["neovide.desktop"];
      "application/gzip" = ["file-roller.desktop"];
      "application/x-bzip" = ["file-roller.desktop"];
      "application/x-bzip-2" = ["file-roller.desktop"];
      "application/x-7z-compressed" = ["file-roller.desktop"];
      "application/zip" = ["file-roller.desktop"];
      "application/epub+zip" = ["calibre-ebook-viewer.desktop"];
    };
  };
}
