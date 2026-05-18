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
    core.boot.enable = true;
    core.networking.enable = true;
    desktop = {
      compositors.hyprland.enable = true;
      display-managers.sddm.enable = true;
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
    gaming.minecraft = {
      enable = true;
      modrinth.enable = false;
      labymod.enable = true;
    };
  };

  services.tailscale.enable = true;

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "26.11";
  # networking.nameservers = lib.mkForce [ "192.168.8.191" ];
  hardware.logitech.wireless.enable = true;
  services.libinput.touchpad.sendEventsMode = "disabled";
  services.libinput.touchpad.dev = "/dev/null";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

  environment.systemPackages = with pkgs; [
    nh
    micro
    lxqt.lxqt-policykit
    nix-output-monitor
    libnotify
  ];
}
