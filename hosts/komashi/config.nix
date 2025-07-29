{
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules
  ];

  modules = {
    dm.sddm.enable = true;
    common = {
      bluetooth.enable = true;
      printing.enable = true;
      sound.enable = true;
      networking.enable = true;
      virtualisation.enable = false;
      sops.enable = true;
    };
    programs = {
      thunar.enable = true;
      hyprland.enable = true;
      appimages.enable = false;
    };
    gaming = {
      wine.enable = false;
      lutris.enable = false;
      bottles.enable = false;
      steam.enable = false;
      heroic.enable = false;
      osu.enable = false;
      hoyoverse = {
        enable = false;
        genshin.enable = false;
        honkai.enable = false;
        zzz.enable = false;
      };
      minecraft = {
        enable = true;
        modrinth.enable = false;
      };
    };
    styles.fonts.enable = true;
  };
  local.hardware-clock.enable = true;
  drivers = {
    intel.enable = true;
    amdgpu.enable = false;
    nvidia.enable = false;
    nvidia-prime = {
      enable = false;
      intelBusID = "";
      nvidiaBusID = "";
    };
  };

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  hardware.logitech.wireless.enable = true;

  networking.nameservers = lib.singleton "192.168.8.191";

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
