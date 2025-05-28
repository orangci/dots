{
  pkgs,
  username,
  ...
}: {
  imports = [../../homes/${username}];

  hmModules = {
    cli = {
      fetch.enable = true;
      shell.program = "fish";
      starship.enable = true;
      oxidisation.enable = true;
      fun.enable = true;
      disk-usage.enable = true;
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
    dev.nix.enable = true;
    programs = {
      firefox.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      rofi.enable = true;
      hypridle.enable = true;
      chromium.enable = true;
      better-control.enable = true;
      quickshell = {
        enable = true;
        workspaces = 7;
      };
      media = {
        enable = true;
        gwenview = true;
      };
      vscodium = {
        enable = true;
        webdev = true;
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
        theme = "catppuccin-mocha";
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
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  programs.home-manager.enable = true;
}
