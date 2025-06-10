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
    common = {
      networking.enable = true;
      sops.enable = true;
    };
    server = {
      caddy.enable = true;
      cloudflared.enable = true;
      technitium.enable = true;

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

      microbin = {
        enable = true;
        domain = "bin.orangc.net";
        port = 8808;
      };

      ntfy = {
        enable = true;
        domain = "ntfy.orangc.net";
        port = 8809;
      };

      ollama = {
        enable = true;
        domain = "ai.orangc.net";
        port = 8810;
      };

      searxng = {
        enable = true;
        domain = "search.orangc.net";
        port = 8811;
      };

      twofauth = {
        enable = false;
        domain = "2fa.orangc.net";
        port = 8812;
      }; # TODO: broken

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

      zipline = {
        enable = true;
        domain = "zip.orangc.net";
        port = 8807;
      };

      minecraft = {
        enable = false;
        juniper.enable = false;
      }; # TODO: untested
    };
    styles.fonts.enable = true;
  };
  local.hardware-clock.enable = true;
  drivers.intel.enable = true;
  time.timeZone = "Asia/Riyadh";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      initialPassword = "modifythis";
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
