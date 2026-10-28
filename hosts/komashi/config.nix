{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ lib.my.recursivelyImport [ ../../modules ];

  modules = {
    core.users.home-manager.stateVersion = "26.05";
    core.boot.enable = true;
    core.networking.enable = true;
    desktop = {
      common.enable = true;
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
      printing.enable = true;
    };
    security.sudo-rs.enable = true;
    security.sops.enable = true;
    programs.syncthing.enable = true;
    gaming = {
      wine.enable = true;
      lutris.enable = true;
      steam.enable = true;
      minecraft.enable = true;
    };
  };

  services.tailscale.enable = true;

  # read by the patchu-search script in the walker module
  modules.security.sops.secrets.patchu-api-key.owner = "orangc";

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "26.05";
  # networking.nameservers = lib.mkForce [ "192.168.8.191" ];
  hardware.logitech.wireless.enable = true;
  programs.kdeconnect.enable = true;
  programs.gpu-screen-recorder.enable = true;

  environment.systemPackages = with pkgs; [
    micro
    libnotify
    zoom-us
  ];

  boot.loader.systemd-boot.windows."windows10" = {
    title = "Michaelsoft Binbows";
    efiDeviceHandle = "FS0";
  };
}
