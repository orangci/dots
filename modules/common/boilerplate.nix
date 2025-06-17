{
  config,
  pkgs,
  username,
  ...
}:
{
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For some steam games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader = {
      efi.efiSysMountPoint = "/boot";
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      grub = {
        enable = false;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    plymouth.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };
  environment.sessionVariables = {
    NH_FLAKE = "/home/${username}/dots";
    FLAKE = "/home/${username}/dots";
  };

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    kdeconnect = {
      enable = true;
    };
  };

  security = {
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

  services = {
    upower.enable = true;
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
      };
    };
    libinput.enable = true;
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  hardware.graphics.enable = true;

  system.stateVersion = "24.11";
}
