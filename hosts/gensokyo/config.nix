{
  pkgs,
  lib,
  flakeSettings,
  inputs,
  users,
  ...
}:
let
  excludedUsers = [ "sysadmin" ];
  filteredUsers = lib.filterAttrs (n: _: !(builtins.elem n excludedUsers)) users;
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
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ lib.my.recursivelyImport [ ../../modules ];

  modules = {
    desktop.fonts.enable = true;
    core.boot.enable = true;
    core.networking.enable = true;
    hardware.drivers.intel.enable = true;
    hardware.btrfs.enable = true;
    security.sudo-rs.enable = true;
    security.restic = {
      enable = true;
      paths = [
        "/home/${users.sysadmin.username}"
        "/srv/files"
        "/var/lib/immich"
        "/var/lib/forgejo"
        "/var/lib/cryptpad"
        "/var/lib/vaultwarden"
        "/var/lib/private/zipline"
        "/var/lib/postgresql"
        "/var/lib/matrix-synapse"
        "/var/lib/davis"
      ];
    };
    services = {
      databases.postgresql.enable = true;
      infrastructure = {
        caddy.enable = true;
        cloudflared.enable = true;
        technitium.enable = true;
        tailscale.enable = true;
      };

      files = {
        copyparty = enableServerModule 8822;
        cryptpad = enableServerModule 8803;
        wastebin = enableServerModule 8809;
        zipline = enableServerModule 8819;
      };

      media = {
        immich = enableServerModule 8807;
        kavita = enableServerModule 8829;
        linkwarden = enableServerModule 8830;
      };

      misc = {
        matrix-synapse = enableServerModule 8824 // {
          serverName = flakeSettings.domains.primary;
        };
        takina.enable = true;
        miniflux = enableServerModule 8827;
        vaultwarden = enableServerModule 8818;
      };

      monitoring = {
        ntfy = (enableServerModule 8812 { ntfy = false; }) // {
          scripts.services.enable = true;
        };
        changedetection = enableServerModule 8828;
        glance = enableServerModule 8806 { glance = false; };
        scrutiny = enableServerModule 8825;
        speedtest = enableServerModule 8816;
        umami = enableServerModule 8820;
        wakapi = enableServerModule 8833;
      };

      productivity = {
        forgejo = enableServerModule 8805 // {
          renovate.enable = true;
        };
        davis = enableServerModule 8831;
        vscode = enableServerModule 8823 { vscode = false; ntfy = false; };
      };

      tools = {
        convertx = enableServerModule 8802;
        it-tools = enableServerModule 8808;
        libretranslate = enableServerModule 8832;
        searxng = enableServerModule 8815;
      };

      webpages = {
        main = enableServerModule 8804;
        notes = enableServerModule 8814;
        ndg.enable = enableServerModule 8813;
      };

      gaming.minecraft = {
        enable = true;
        juniper-s10 = {
          enable = true;
          port = 8810;
          minRAM = 1;
          maxRAM = 12;
          motd = "                  Lord of the Mysteries";
          automatic-backups = {
            enable = true;
            frequency = "daily";
          };
        };
      };
    };
  };

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

  users.users = builtins.mapAttrs (name: user: {
    home = "/home/${name}";
    homeMode = "755";
    isNormalUser = true;
    description = "${name}";
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "scanner"
    ]
    ++ lib.optionals user.sudo [
      "wheel"
      "libvirtd"
      "lp"
      "docker"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  }) filteredUsers;

  home-manager.users = builtins.mapAttrs (name: _user: {
    home = {
      username = name;
      homeDirectory = "/home/${name}";
      stateVersion = "25.05";
    };
    programs.home-manager.enable = true;
  }) filteredUsers;
}
