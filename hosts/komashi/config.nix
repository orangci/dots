{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ lib.my.recursivelyImport [ ../../modules ];

  modules = {
    core.users.home-manager.stateVersion = "25.05";
    core.boot.enable = true;
    core.networking.enable = true;
    desktop = {
      compositors.hyprland.enable = true;
      display-managers.sddm.enable = true;
      display-managers.sddm.theme = "stray";
      file-managers.thunar.enable = true;
      fonts.enable = true;
    };
    hardware = {
      drivers.intel.enable = true;
      bluetooth.enable = true;
      btrfs.enable = true;
      sound.enable = true;
    };
    security.sudo-rs.enable = true;
    security.sops.enable = true;
    gaming.wine.enable = true;
    gaming.lutris.enable = true;
  };

  services.tailscale.enable = true;

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  # networking.nameservers = lib.mkForce [ "192.168.8.191" ];
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    nh
    micro
    lxqt.lxqt-policykit
    nix-output-monitor
    libnotify
  ];

  boot.loader.systemd-boot.windows."windows10" = {
    title = "Michaelsoft Binbows";
    efiDeviceHandle = "FS0";
  };
}
