{
  config,
  pkgs,
  ...
}:
{
  imports = [ ../../../home ];
  nixpkgs.config.allowUnfree = true;

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
        inherit (config.home) username;
        email = "mrlion871@protonmail.com";
        github = true;
      };
    };
    misc = {
      xdg.enable = true;
      clipboard.enable = true;
      cheatsheet.enable = true;
      screenshot.enable = true;
      gnupg.enable = true;
      screenrec = {
        enable = true;
        fileFormat = "mov";
        timestampFormat = "%y-%b-%m_%H.%M.%S";
        quality = "very_high";
        encoder = "gpu";
        showCursor = "yes";
        framerate = 60;
        codec = "auto";
      };
    };
    dev = {
      nix.enable = true;
      direnv.enable = true;
    };
    programs = {
      better-control.enable = true;
      editors.micro.enable = true;
      hypr = {
        land.enable = true;
        lock.enable = true;
        idle.enable = true;
      };
      widgets = {
        wleave = {
          enable = true;
          horizontal = true;
        };
        rofi.enable = true;
        swaync.enable = true;
        waybar.enable = true;
        walker.enable = true;
        syshud.enable = true;
      };
      media = {
        enable = true;
        gwenview = true;
      };
      discord.enable = true;
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
        directory = "${config.xdg.userDirs.pictures}/walls";
      };
      stylix = {
        enable = true;
        # Choose from https://tinted-theming.github.io/tinted-gallery/
        # if you want a light theme, i strongly recommend gruvbox-material-light-medium
        # i usually default to rose-pine or catppuccin-mocha
        theme = "catppuccin-mocha";
      };
    };
  };

  home = {
    file.".face.icon".source = ../../../assets/face.png;
    packages = with pkgs; [
      hyprpicker
      pinta
      google-chrome
    ];
  };

  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
}
