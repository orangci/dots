{
  pkgs,
  username,
  host,
  ...
}: {
  imports = [../../homes/${username}];

  hmModules = {
    cli = {
      fetch.enable = true;
      shell.program = "fish";
      eza.enable = true;
      fd.enable = true;
      zoxide.enable = true;
      ripgrep.enable = true;
      bat.enable = true;
      fzf.enable = true;
      fun.enable = true;
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
    core = {
      xdg.enable = true;
    };
    dev = {
      python = {
        enable = true;
        version = "python313";
      };
      rust.enable = true;
      nix.enable = true;
    };
    programs = {
      firefox.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      rofi.enable = true;
      starship.enable = true;
      swaync.enable = false;
      waybar.enable = false;
      hypridle.enable = true;
      screenshot.enable = true;
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
      wlogout = {
        enable = false;
        horizontal = false;
      };
      discord = {
        enable = false;
        arrpc = true;
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
    packages = [
      (import ../../packages/list-bindings.nix {inherit pkgs;})
      (import ../../packages/screenrec.nix {inherit pkgs;})
      (import ../../packages/walls.nix {inherit pkgs;})
    ];
    stateVersion = "24.11";
    file.".face.icon".source = ../../assets/face.png;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  services.cliphist.enable = true;
  programs.home-manager.enable = true;
}
