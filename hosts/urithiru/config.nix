{
  pkgs,
  username,
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
      initialHashedPassword = "$y$j9T$cqnEz3bHEPqTgmSNxCeOl1$Z8HsEa0QeUlRb9oZs1NuZEk1yytyEBj4kWS4e3N7iJ7";
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
