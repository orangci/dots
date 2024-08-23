{
  config,
  pkgs,
  host,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules
  ];

  # modules
  modules = {
    core = {
      bluetooth.enable = true;
      printing.enable = true;
      sound.enable = true;
      networking.enable = true;
    };
    programs = {
      thunar.enable = true;
      discord.enable = true;
      steam.enable = false;
      hyprland.enable = true;
      minecraft.enable = true;
      appimages.enable = false;
    };
    styles = {
      stylix.enable = true;
      fonts.enable = true;
    };
    dm.sddm.enable = true;
  };
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;
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
  hardware.logitech.wireless.enable = true;

  programs = {
    hyprlock.enable = true;
    java.enable = true;
    noisetorch.enable = true;
  };

  # environment.systemPackages = with pkgs; [ ];

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
      ];
      shell = pkgs.bash;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [];
    };
  };
}
