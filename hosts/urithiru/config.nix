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
      sops.enable = true;
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
      twofauth.enable = true;
      chibisafe.enable = true; # TODO
      minecraft = {
        enable = false;
        juniper.enable = false;
      };
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
