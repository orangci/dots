{
  username,
  config,
  pkgs,
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
        gitea = true;
        lfs = true;
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
          enable = true;
          horizontal = true;
        };
        rofi.enable = true;
        swaync.enable = true;
        waybar.enable = true;
        walker.enable = true;
        ignis.enable = true;
      };
      media = {
        enable = true;
        gwenview = true;
      };
      discord.enable = false;
      arrpc.enable = true;
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
        directories = "${config.xdg.userDirs.pictures}/walls";
      };
      stylix = {
        enable = true;
        # Choose from https://tinted-theming.github.io/tinted-gallery/
        # if you want a light theme, i strongly recommend gruvbox-material-light-medium
        # i usually default to rose-pine or catppuccin-mocha
        theme = "gruvbox-material-light-medium";
      };
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    file.".face.icon".source = ../../assets/face.png;
    packages = with pkgs; [
      hyprpicker
      obsidian
      pinta
    ];
  };

  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
  programs.home-manager.enable = true;
}
