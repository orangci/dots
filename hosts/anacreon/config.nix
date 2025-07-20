{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules
  ];

  modules = {
    dm.sddm.enable = true;
    common = {
      bluetooth.enable = true;
      printing.enable = true;
      sound.enable = true;
      networking.enable = true;
      virtualisation.enable = false;
      sops.enable = true;
    };
    programs = {
      thunar.enable = true;
      hyprland.enable = true;
      appimages.enable = false;
    };
    gaming = {
      wine.enable = false;
      lutris.enable = false;
      bottles.enable = false;
      steam.enable = false;
      heroic.enable = false;
      hoyoverse = {
        enable = false;
        genshin.enable = false;
        honkai.enable = false;
        zzz.enable = false;
      };
      minecraft = {
        enable = true;
        modrinth.enable = false;
      };
    };
    styles = {
      fonts.enable = true;
    };
    server = {
      caddy.enable = true;
      cloudflared.enable = true;

      glance = {
        enable = true;
        domain = "glance.orangc.net";
        port = 8804;
      };

      ntfy = {
        enable = true;
        domain = "ntfy.orangc.net";
        port = 8809;
      }; # TODO: status monitor notifs. with uptime-kuma, probably, make module actually work

      searxng = {
        enable = true;
        domain = "search.orangc.net";
        port = 8811;
      };

      minecraft = {
        enable = true;
        juniper-s10 = {
          enable = true;
          port = 8817;
          minRAM = 6;
          maxRAM = 8;
          motd = "Scarlet Weather Rhapsody";
        };
      };

      jellyfin = {
        # TODO: broken
        enable = true;
        domain = "jf.orangc.net";
        port = 8096; # can't be changed via the nixos module
      };

      moodle = {
        # TODO: broken
        enable = false;
        domain = "moodle.orangc.net";
        port = 8820;
      };
    };
  };
  local.hardware-clock.enable = true;
  drivers = {
    intel.enable = true;
    amdgpu.enable = false;
    nvidia.enable = false;
    nvidia-prime = {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
  };

  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 8 * 1024; # 8GB
  #   }
  # ];

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [ ];

  boot.loader.systemd-boot.windows."windows10" = {
    title = "Michaelsoft Binbows";
    efiDeviceHandle = "FS0";
  };

  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${username}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "libvirtd"
        "docker"
      ];
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [ ];
    };
  };
}
