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
    styles.fonts.enable = true;
    common = {
      bluetooth.enable = false;
      printing.enable = false;
      networking.enable = true;
      sops.enable = true;
    };
    server = {
      caddy.enable = true;
      cloudflared.enable = true;
      technitium.enable = true;

      bracket = {
        enable = false;
        domain = "bracket.orangc.net";
        port = 8800;
      };

      chibisafe = {
        enable = false;
        domain = "safe.orangc.net";
        port = 8801;
      };
      
      convertx = {
        enable = true;
        domain = "convert.orangc.net";
        port = 8802;
      };

      cryptpad = {
        enable = false;
        domain = "pad.orangc.net";
        port = 8803;
      };

      filebrowser = {
        enable = true;
        domain = "files.orangc.net";
        port = 8804;
      };

      gitea = {
        enable = true;
        domain = "git.orangc.net";
        port = 8805;
      };

      glance = {
        enable = true;
        domain = "glance.orangc.net";
        port = 8806;
      };

      immich = {
        enable = true;
        domain = "media.orangc.net";
        port = 8807;
      };

      it-tools = {
        enable = true;
        domain = "tools.orangc.net";
        port = 8808;
      };

      jellyfin = {
        enable = false;
        domain = "jf.orangc.net";
        port = 8920; # can't be changed via the nixos module
      };

      microbin = {
        enable = true;
        domain = "bin.orangc.net";
        port = 8809;
      };

      minecraft = {
        enable = true;
        juniper-s10 = {
          enable = true;
          port = 8810;
          minRAM = 8;
          maxRAM = 12;
          motd = "Highly Responsive To Prayers!!";
          automatic-backups = {
            enable = true;
            frequency = "daily";
          };
        };
      };

      moodle = {
        enable = false;
        domain = "moodle.orangc.net";
        port = 8811;
      };

      ntfy = {
        enable = true;
        domain = "ntfy.orangc.net";
        port = 8812;
      };

      ollama = {
        enable = false;
        domain = "ai.orangc.net";
        port = 8813;
      };

      pelican = {
        enable = false;
        domain = "pelican.orangc.net";
        port = 8814;
      };

      searxng = {
        enable = true;
        domain = "search.orangc.net";
        port = 8815;
      };

      speedtest = {
        enable = true;
        domain = "speedtest.orangc.net";
        port = 8816;
      };

      uptime-kuma = {
        enable = false;
        domain = "status.orangc.net";
        port = 8817;
      };

      vaultwarden = {
        enable = true;
        domain = "vault.orangc.net";
        port = 8818;
      };

      zipline = {
        enable = false;
        domain = "zip.orangc.net";
        port = 8819;
      };
    };
  };
  local.hardware-clock.enable = true;
  drivers.intel.enable = true;

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";

  environment.systemPackages = with pkgs; [ ];

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
