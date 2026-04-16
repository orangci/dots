{
  pkgs,
  lib,
  flakeSettings,
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
      restic = {
        enable = true;
        paths = [
          "/home/orangc/docs"
          "/srv/files"
          "/var/lib/immich"
          "/var/lib/forgejo"
          "/var/lib/cryptpad"
        ];
      };
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
      nixflix.enable = true;

      bracket = allThree // {
        enable = false;
        cloudflared.enable = true;
        domain = "bracket.${flakeSettings.primaryDomain}";
        port = 8801;
      };

      convertx = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "convert.${flakeSettings.primaryDomain}";
        port = 8802;
      };

      cryptpad = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "pad.${flakeSettings.primaryDomain}";
        port = 8803;
      };

      filebrowser = allThree // {
        enable = false;
        domain = "files.${flakeSettings.primaryDomain}";
        port = 8804;
      };

      forgejo = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "git.${flakeSettings.primaryDomain}";
        port = 8805;
      };

      glance = {
        enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        ntfyChecking.enable = true;
        domain = "glance.${flakeSettings.primaryDomain}";
        port = 8806;
      };

      immich = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "media.${flakeSettings.primaryDomain}";
        port = 8807;
      };

      it-tools = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "tools.${flakeSettings.primaryDomain}";
        port = 8808;
      };

      jellyfin = allThree // {
        enable = false;
        domain = "jf.${flakeSettings.primaryDomain}";
        port = 8096; # can't be changed via the nixos module
      };

      microbin = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "bin.${flakeSettings.primaryDomain}";
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
        domain = "moodle.${flakeSettings.primaryDomain}";
        port = 8811;
      };

      ntfy = {
        enable = true;
        cloudflared.enable = true;
        glance.enable = true;
        internalTailscaleDomain.enable = true;
        domain = "ntfy.${flakeSettings.primaryDomain}";
        port = 8812;
        users = lib.singleton {
          inherit (flakeSettings) username;
          role = "admin";
        };
        scripts = {
          services.enable = true;
          cpu-temperature.enable = false; # never shuts up
          power-on.enable = false;
        };
      };

      ollama = allThree // {
        enable = false;
        domain = "ai.${flakeSettings.primaryDomain}";
        port = 8813;
      };

      searxng = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "search.${flakeSettings.primaryDomain}";
        port = 8815;
      };

      speedtest = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "speedtest.${flakeSettings.primaryDomain}";
        port = 8816;
      };

      uptime-kuma = allThree // {
        enable = false;
        cloudflared.enable = true;
        domain = "status.${flakeSettings.primaryDomain}";
        port = 8817;
      };

      vaultwarden = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "vault.${flakeSettings.primaryDomain}";
        port = 8818;
      };

      zipline = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "zip.${flakeSettings.primaryDomain}";
        port = 8819;
      };

      umami = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "umami.${flakeSettings.primaryDomain}";
        port = 8820;
      };

      grafana = allThree // {
        enable = false;
        domain = "grafana.${flakeSettings.primaryDomain}";
        port = 8821;
      };

      copyparty = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "files.${flakeSettings.primaryDomain}";
        port = 8822;
      };

      vscode = {
        enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        domain = "code.${flakeSettings.primaryDomain}";
        port = 8823;
      };

      matrix.synapse = {
        enable = true;
        apiDomain = "gensokyo.${flakeSettings.tailnetName}";
        port = 8824;
        serverName = flakeSettings.primaryDomain;
      };

      scrutiny = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "scrutiny.${flakeSettings.primaryDomain}";
        port = 8825;
      };

      aiostreams = allThree // {
        enable = false;
        domain = "aiostreams.${flakeSettings.primaryDomain}";
        port = 8826;
      };

      miniflux = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "feed.${flakeSettings.primaryDomain}";
        port = 8827;
      };

      changedetection = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "detect.${flakeSettings.primaryDomain}";
        port = 8828;
      };

      kavita = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "read.${flakeSettings.primaryDomain}";
        port = 8829;
      };

      linkwarden = allThree // {
        enable = true;
        cloudflared.enable = true;
        domain = "links.${flakeSettings.primaryDomain}";
        port = 8830;
      };
    };
  };
  local.hardware-clock.enable = true;
  drivers.intel.enable = true;
  services.smartd = {
    enable = true;
    devices = lib.singleton { device = "/dev/nvme0"; };
  };

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  #networking.nameservers = lib.mkForce [ "127.0.0.1" ];
  #networking.resolvconf.enable = false;

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit
    nix-output-monitor
    nh
    micro
    smartmontools # smartd drive health monitoring
  ];

  users.users = {
    "${flakeSettings.username}" = {
      home = "/home/${flakeSettings.username}";
      homeMode = "755";
      isNormalUser = true;
      description = "${flakeSettings.username}";
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
