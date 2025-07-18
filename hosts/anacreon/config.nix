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
      technitium.enable = false;

      chibisafe = {
        enable = false;
        domain = "safe.orangc.net";
        port = 8801;
      }; # TODO: connects, but broken

      cryptpad = {
        enable = false;
        domain = "pad.orangc.net";
        port = 8802;
      }; # TODO: lets you signup but nothing more than that :c

      gitea = {
        enable = true;
        domain = "git.orangc.net";
        port = 8803;
      };

      glance = {
        enable = true;
        domain = "glance.orangc.net";
        port = 8804;
      };

      immich = {
        enable = true;
        domain = "media.orangc.net";
        port = 8805;
      };

      it-tools = {
        enable = true;
        domain = "tools.orangc.net";
        port = 8806;
      };

      zipline = {
        enable = true;
        domain = "zip.orangc.net";
        port = 8807;
      };

      microbin = {
        enable = true;
        domain = "bin.orangc.net";
        port = 8808;
      };

      ntfy = {
        enable = true;
        domain = "ntfy.orangc.net";
        port = 8809;
      }; # TODO: status monitor notifs. with uptime-kuma, probably

      ollama = {
        enable = false;
        domain = "ai.orangc.net";
        port = 8810;
      };

      searxng = {
        enable = true;
        domain = "search.orangc.net";
        port = 8811;
      };

      uptime-kuma = {
        enable = false;
        domain = "status.orangc.net";
        port = 8813;
      };

      vaultwarden = {
        enable = true;
        domain = "vault.orangc.net";
        port = 8814;
      };

      bracket = {
        enable = false;
        domain = "bracket.orangc.net";
        port = 8815;
      }; # TODO: untested

      speedtest = {
        enable = true;
        domain = "speedtest.orangc.net";
        port = 8816;
      };

      minecraft = {
        enable = true;
        juniper-s10 = {
          enable = true;
          port = 8817;
          minRAM = 6;
          maxRAM = 8;
          motd = "A test world until the real S10!";
          automatic-backups = {
            enable = true;
            frequency = "daily";
          };
        };
      };

      pelican = {
        enable = false;
        domain = "pelican.orangc.net";
        port = 8818;
      };

      filebrowser = {
        enable = true;
        domain = "files.orangc.net";
        port = 8819;
      };

      jellyfin = {
        # TODO: broken
        enable = false;
        domain = "jf.orangc.net";
        port = 8920; # can't be changed via the nixos module
      };

      moodle = {
        # TODO: broken
        enable = false;
        domain = "moodle.orangc.net";
        port = 8820;
      };

      convertx = {
        enable = true;
        domain = "convert.orangc.net";
        port = 8821;
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
