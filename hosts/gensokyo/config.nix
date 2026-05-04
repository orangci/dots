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
      ndg.enable = true;
      restic = {
        enable = true;
        paths = [
          "/home/orangc"
          "/srv/files"
          "/var/lib/immich"
          "/var/lib/forgejo"
          "/var/lib/cryptpad"
          "/var/lib/vaultwarden"
          "/var/lib/private/zipline"
          "/var/lib/postgresql"
        ];
      };
    };
    programs = {
      sudo-rs.enable = true;
      syncthing.enable = false;
    };
    server = {
      caddy.enable = true;
      cloudflared.enable = true;
      technitium.enable = true;
      postgresql.enable = true;
      duckdns.enable = false;
      tailscale.enable = true;
      nixflix.enable = true;
      takina.enable = true;

      webpages.main = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8804;
      };
      webpages.notes = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8814;
      };

      convertx = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8802;
      };

      cryptpad = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8803;
      };

      forgejo = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8805;
        renovate.enable = true;
      };

      glance = {
        enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        ntfyChecking.enable = true;
        port = 8806;
      };

      immich = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8807;
      };

      it-tools = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8808;
      };

      jellyfin = allThree // {
        enable = false;
        port = 8096; # can't be changed via the nixos module
      };

      wastebin = allThree // {
        enable = true;
        cloudflared.enable = true;
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
        port = 8811;
      };

      ntfy = {
        enable = true;
        cloudflared.enable = true;
        glance.enable = true;
        internalTailscaleDomain.enable = true;
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
        port = 8813;
      };

      searxng = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8815;
      };

      speedtest = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8816;
      };

      vaultwarden = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8818;
      };

      zipline = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8819;
      };

      umami = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8820;
      };

      grafana = allThree // {
        enable = false;
        port = 8821;
      };

      copyparty = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8822;
      };

      vscode = {
        enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        port = 8823;
      };

      matrix.synapse = {
        enable = true;
        apiDomain = "gensokyo.${flakeSettings.domains.tailnet}";
        port = 8824;
        serverName = flakeSettings.domains.primary;
      };

      scrutiny = allThree // {
        enable = true;
        port = 8825;
      };

      miniflux = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8827;
      };

      changedetection = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8828;
      };

      kavita = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8829;
      };

      linkwarden = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8830;
      };

      davis = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8831;
      };

      libretranslate = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8832;
      };

      wakapi = allThree // {
        enable = true;
        cloudflared.enable = true;
        port = 8833;
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
