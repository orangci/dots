{
  config,
  pkgs,
  inputs,
  username,
  host,
  gtkThemeFromScheme,
  ...
}:
let
  palette = config.colorScheme.palette;
  inherit (import ./variables.nix)
    gitUsername
    gitEmail
    theme
    boxyStyle
    ;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Import Program Configurations
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../config/hyprland.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/rofi.nix
    ../../config/kitty.nix
    ../../config/fastfetch.nix
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  home.file.".local/share/fonts" = {
    source = ../../config/fonts;
    recursive = true;
  };
  home.file.".config/starship.toml".source = ../../config/starship.toml;
  home.file.".base16-themes".source = ../../config/base16-themes;
  home.file.".face.icon".source = ../../config/face.png;
  home.file.".config/vesktop/themes/orangetweaks.css".source = ../../config/Configs/vencordthemes/orangetweaks.css;
  home.file.".config/vesktop/themes/catppuccin.css".source = ../../config/Configs/vencordthemes/catppuccin.css;
  home.file.".config/rofi/rofi-prism.sh".source = ../../scripts/rofi-prism.sh;
  home.file.".config/hypr/hyprlock.conf".text = ''
      source=/tmp/.current_wallpaper_path_hyprlock
      background {
      path=$WALLPAPER
    }

    general {
      disable_loading_bar=true
      grace=0
      hide_cursor=true
      no_fade_in=false
    }

    image {
      size=200
      border_color=rgba(12, 150, 249,0)
      border_size=1
      halign=center
      path=/home/orangc/dots/config/face.png
      position=0, 200
      rounding=-1
      valign=center
    }

    input-field {
      monitor=
      size=200, 50
      dots_center=true
      fade_on_empty=true
      font_color=rgb(cdd6f4)
      inner_color=rgb(1e1e2e)
      outer_color=rgb(181825)
      outline_thickness=2
      placeholder_text=Password...
      position=0, -80
    }
  '';
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';

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
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options
  # stylix.targets.waybar.enable = false;
  # stylix.targets.rofi.enable = false;
  # stylix.targets.hyprland.enable = false;

  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Theme GTK
  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      size = 12;
      package = pkgs.ubuntu_font_family;
    };
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorScheme; };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
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

  # Scripts
  home.packages = [
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/rofi-powermenu.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/rofi-prism-exec.nix { inherit pkgs; })
    (import ../../scripts/walls.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
  ];

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
          starship = {
            enable = true;
            package = pkgs.starship;
          };
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
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    neovim.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        nitch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
        if [ -f /tmp/.current_wallpaper_path ]; then
          export WALLPAPER=$(cat /tmp/.current_wallpaper_path)
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        flake-rebuild = "nh os switch --hostname ${host} /home/${username}/dots";
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
        nixpf = "nix-prefetch";
        nixpfu = "nix-prefetch-url";
        spinmal = "bash $HOME/Documents/spinPTW.sh";
      };
    };
    home-manager.enable = true;
    hyprlock.enable = true;
  };
}
