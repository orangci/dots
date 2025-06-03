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
      docker.enable = true;
      networking.enable = true;
      secrets.enable = true;
      virtualisation.enable = false;
    };
    server = {
      # TODO: test with nix run .#nixosConfigurations.urithiru.config.system.build.vm
      cloudflared.enable = true; # TODO
      caddy.enable = true; # TODO
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
      immich.enable = true;
      chibisafe.enable = true;
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
