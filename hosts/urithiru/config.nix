{
  pkgs,
  username,
  ...
}: {
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
      cloudflared.enable = true; # TODO: complete module
      caddy.enable = true; # TODO: complete module
      technitium.enable = true;
      searxng.enable = true;
      uptime-kuma.enable = true;
      vaultwarden.enable = true;
      microbin.enable = true;
      ntfy.enable = true;
      glance.enable = true;
      gitea.enable = true;
      calibre-web.enable = true;
      cryptpad.enable = false;
    };
    styles.fonts.enable = true;
  };
  local.hardware-clock.enable = true;
  drivers.intel.enable = true;

  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 8 * 1024; # 8GB
  #   }
  # ];

  time.timeZone = "Asia/Riyadh";

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
      packages = with pkgs; [];
    };
  };
}
