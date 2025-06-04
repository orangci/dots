{
  pkgs,
  username,
  host,
  lib,
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
      sops = {
        enable = true;
        secrets."${host}-${username}-pass" = {
          path = "/run/secrets/${host}-${username}-pass";
          neededForUsers = true;
        };
      };
      virtualisation.enable = false;
    };
    server = {
      cloudflared.enable = true;
      caddy.enable = true;
      technitium.enable = true;
      searxng.enable = true;
      uptime-kuma.enable = true;
      vaultwarden.enable = true;
      microbin.enable = true;
      ntfy.enable = true;
      glance.enable = true;
      gitea.enable = true;
      calibre-web.enable = true;
      it-tools.enable = true;
      cryptpad.enable = false;
      immich.enable = false;
      chibisafe.enable = true; # TODO
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
  users.mutableUsers = lib.mkForce false;
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      # hashedPasswordFile = modules.sops.secrets.${host}-${username}-pass.path;
      password = "a";
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
