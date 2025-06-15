{
  username,
  ...
}:
{
  imports = [ ../../homes/${username} ];

  hmModules = {
    cli = {
      fetch.enable = true;
      shell.program = "fish";
      starship.enable = true;
      oxidisation.enable = true;
      fun.enable = true;
      disk-usage.enable = true;
      media.enable = true;
      utilities.enable = true;
      benchmarking.enable = true;
      compression = {
        enable = true;
        zip = true;
      };

      git = {
        enable = true;
        username = "orangc";
        email = "c@orangc.net";
        github = true;
      };
    };
    misc = {
      xdg.enable = true;
      clipboard.enable = true;
      cheatsheet.enable = true;
      screenrec.enable = true;
      screenshot.enable = true;
    };
    dev = {
      python = {
        enable = true;
        version = "python313";
      };
      rust.enable = true;
      nix.enable = true;
      misc.enable = true;
    };
    programs = {
      better-control.enable = true;
      editors = {
        nvf.enable = false;
        micro.enable = true;
        vscodium = {
          enable = true;
          webdev = true;
        };
      };
      browsers = {
        firefox.enable = true;
        chromium.enable = true;
      };
      hypr = {
        land.enable = true;
        lock.enable = true;
        idle.enable = true;
      };
      widgets = {
        wlogout = {
          enable = false;
          horizontal = false;
        };
        rofi.enable = true;
        swaync.enable = false;
        waybar.enable = false;
        ignis.enable = true;
      };
      quickshell = {
        enable = true;
        workspaces = 7;
      };
      media = {
        enable = true;
        gwenview = true;
      };
      discord = {
        enable = false;
        arrpc = true;
      };
      terminal = {
        enable = true;
        emulator = "kitty";
      };
    };
    styles = {
      gtk.enable = true;
      qt.enable = true;
      walls = {
        enable = true;
        timeout = 20; # Time between wallpaper changes (in minutes)
      };
      stylix = {
        enable = true;
        # Choose from https://tinted-theming.github.io/tinted-gallery/
        # if you want a light theme, i strongly recommend gruvbox-material-light-medium
        # i usually default to catppuccin-mocha or rose-pine
        theme = "rose-pine";
      };
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    file.".face.icon".source = ../../assets/face.png;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
  programs.home-manager.enable = true;
}
