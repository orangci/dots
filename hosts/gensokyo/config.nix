{
  pkgs,
  lib,
  flakeSettings,
  sysadmin,
  ...
}:
let
  enableServerModule =
    port:
    {
      cf ? true,
      ts ? true,
      ntfy ? true,
      glance ? true,
    }:
    {
      enable = true;
      inherit port;
      cloudflared.enable = cf;
      internalTailscaleDomain.enable = ts;
      ntfyChecking.enable = ntfy;
      glance.enable = glance;
    };

in
{
  imports = [
    ./hardware.nix
  ]
  ++ lib.my.recursivelyImport [ ../../modules ];

  modules = {
    desktop.fonts.enable = true;
    core.boot.enable = true;
    core.networking.enable = true;
    hardware.drivers.intel.enable = true;
    hardware.btrfs.enable = true;
    programs.syncthing.enable = true;
    security.sops.enable = true;
    security.sudo-rs.enable = true;
    security.restic = {
      enable = true;
      paths = [
        "/home/${sysadmin.username}"
        "/srv/files"
        "/var/lib/immich"
        "/var/lib/forgejo"
        "/var/lib/vaultwarden"
        "/var/lib/private/zipline"
        "/var/lib/postgresql"
        "/var/lib/matrix-synapse"
        "/var/lib/davis"
        "/var/lib/patchu"
        "/var/backup/vaultwarden"
        "/var/backups/takina"
      ];
    };
    services = {
      databases.postgresql = {
        enable = true;
        users = [ "kaju" ];
        databases = [ "kaju" ];
      };
      infrastructure = {
        caddy.enable = true;
        cloudflared.enable = true;
        technitium.enable = true;
        tailscale.enable = true;
        pocket-id = enableServerModule 8801 { };
      };

      files = {
        copyparty = enableServerModule 8822 { };
        wastebin = enableServerModule 8809 { };
        zipline = enableServerModule 8819 { };
      };

      media = {
        audiobookshelf = enableServerModule 8826 { };
        immich = enableServerModule 8807 { };
        kavita = enableServerModule 8829 { };
      };

      misc = {
        matrix-synapse = (enableServerModule 8824 { }) // {
          serverName = flakeSettings.domains.primary;
        };
        miniflux = enableServerModule 8827 { };
        vaultwarden = enableServerModule 8818 { };
        #horsering = enableServerModule 8834 { };
        takina.enable = true;
        reviewbot = {
          enable = true;
          webhook.expose = true;
        };
        mudaremote.enable = true;
        patchu = enableServerModule 8838 {
          # caddy and cloudflared are wired by the module itself
          cf = false;
          ts = false;
        };
      };

      monitoring = {
        ntfy = (enableServerModule 8812 { ntfy = false; }) // {
          scripts.services.enable = true;
          scripts.temperature.enable = true;
        };
        glance = enableServerModule 8806 { glance = false; };
        #beszel = enableServerModule 8825 { };
        speedtest = enableServerModule 8816 { };
        umami = enableServerModule 8820 { };
        wakapi = enableServerModule 8833 { };
      };

      productivity = {
        buzz-agenda.enable = true;
        forgejo = (enableServerModule 8805 { }) // {
          runner.uuid = "0fb6e3b5-9778-4cda-af22-0ef67ceb66f8";
          renovate.enable = true;
        };
        davis = enableServerModule 8831 { };
        opnform = enableServerModule 8836 { };
        # tailnet only: it's a shell as a wheel user behind a single token
        vscode = enableServerModule 8823 {
          cf = false;
          glance = false;
          ntfy = false;
        };
      };

      tools = {
        it-tools = enableServerModule 8808 { };
        libretranslate = enableServerModule 8832 { };
        searxng = enableServerModule 8815 { };
      };

      webpages = {
        main = enableServerModule 8804 { };
        notes = enableServerModule 8814 { };
        ndg = enableServerModule 8813 { };
        fumos-net = enableServerModule 8835 { };
      };
    };
  };

  programs.dconf.enable = true;
  # root evaluates the flake under sudo and needs to fetch private inputs
  programs.git = {
    enable = true;
    config.credential.helper = "store --file /home/${sysadmin.username}/.git-credentials";
  };

  services.smartd = {
    enable = true;
    devices = lib.singleton { device = "/dev/nvme0"; };
  };

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  # networking.nameservers = lib.mkForce [ "::1" ];
  # networking.resolvconf.enable = false;

  environment.systemPackages = with pkgs; [
    micro
    smartmontools # smartd drive health monitoring
  ];
}
