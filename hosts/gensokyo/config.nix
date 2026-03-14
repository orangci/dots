{
  pkgs,
  username,
  lib,
  ...
}:
let

  allThree = {
    glance.enable = true;
    internalTailscaleDomain.enable = true;
    ntfyChecking.enable = true;
  };

in
{
  imports = [
    ./hardware.nix
    ../../modules
  ];

  modules = {
    styles.fonts.enable = true;
    common = {
      bluetooth.enable = false;
      printing.enable = false;
      networking.enable = true;
      sops.enable = true;
      btrfs.enable = true;
    };
    programs = {
      sudo-rs.enable = true;
    };
    server = {
      caddy.enable = true;
      cloudflared.enable = true;
      technitium.enable = true;
      postgresql.enable = true;
      duckdns.enable = false;
      tailscale.enable = true;

      bracket = allThree // {
        enable = false;
        cloudflared.enable = true;
        domain = "bracket.orangc.net";
        port = 8801;
      };

      convertx = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "convert.orangc.net";
        port = 8802;
      };

      cryptpad = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "pad.orangc.net";
        port = 8803;
      };

      filebrowser = allThree // {
        enable = false;
        domain = "files.orangc.net";
        port = 8804;
      };

      forgejo = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "git.orangc.net";
        port = 8805;
      };

      glance = {
        enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        ntfyChecking.enable = true;
        domain = "glance.orangc.net";
        port = 8806;
      };

      immich = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "media.orangc.net";
        port = 8807;
      };

      it-tools = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "tools.orangc.net";
        port = 8808;
      };

      jellyfin = allThree // {
        enable = true;
        domain = "jf.orangc.net";
        port = 8096; # can't be changed via the nixos module
      };

      microbin = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "bin.orangc.net";
        port = 8809;
      };

      minecraft = {
        enable = true;
        juniper-s10 = {
          enable = true;
          port = 8810;
          minRAM = 1;
          maxRAM = 12;
          motd = "                    Silent Sinner In Blue";
          automatic-backups = {
            enable = true;
            frequency = "daily";
          };
        };
      };

      moodle = allThree // {
        enable = false;
        cloudflared.enable = true;
        domain = "moodle.orangc.net";
        port = 8811;
      };

      ntfy = {
        enable = true;
        cloudflared.enable = true;
        glance.enable = true;
        internalTailscaleDomain.enable = true;
        domain = "ntfy.orangc.net";
        port = 8812;
        users = lib.singleton {
          username = "orangc";
          role = "admin";
        };
        scripts = {
          services.enable = true;
          cpu-temperature.enable = false; # never shuts up
          power-on.enable = true;
        };
      };

      ollama = allThree // {
        enable = false;
        domain = "ai.orangc.net";
        port = 8813;
      };

      searxng = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "search.orangc.net";
        port = 8815;
      };

      speedtest = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "speedtest.orangc.net";
        port = 8816;
      };

      uptime-kuma = allThree // {
        enable = false;
        cloudflared.enable = true;
        domain = "status.orangc.net";
        port = 8817;
      };

      vaultwarden = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "vault.orangc.net";
        port = 8818;
      };

      zipline = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "zip.orangc.net";
        port = 8819;
      };

      umami = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "umami.orangc.net";
        port = 8820;
      };

      grafana = allThree // {
        enable = false;
        domain = "grafana.orangc.net";
        port = 8821;
      };

      copyparty = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "files.orangc.net";
        port = 8822;
      };

      vscode = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "code.orangc.net";
        port = 8823;
      };

      matrix.synapse = {
        enable = true;
        apiDomain = "gensokyo.cormorant-emperor.ts.net";
        port = 8824;
        serverName = "orangc.net";
      };
    };
  };
  local.hardware-clock.enable = true;
  drivers.intel.enable = true;

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  #networking.nameservers = lib.mkForce [ "127.0.0.1" ];
  #networking.resolvconf.enable = false;

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    nix-output-monitor
    nh
    micro
  ];

  users.users = {
    "${username}" = {
      home = "/home/${username}";
      homeMode = "755";
      isNormalUser = true;
      description = "${username}";
      initialPassword = "password";
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
