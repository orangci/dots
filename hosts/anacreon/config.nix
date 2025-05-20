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
    dm.sddm.enable = true;
    common = {
      bluetooth.enable = true;
      printing.enable = true;
      sound.enable = true;
      networking.enable = true;
      virtualisation.enable = false;
    };
    programs = {
      thunar.enable = true;
      hyprland.enable = true;
      appimages.enable = false;
    };
    gaming = {
      enable = true;
      wine.enable = false;
      lutris.enable = false;
      bottles.enable = false;
      steam.enable = false;
      minecraft = {
        enable = true;
        modrinth.enable = false;
      };
    };
    styles = {
      stylix.enable = true;
      fonts.enable = true;
    };
  };
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

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024; # 8GB
    }
  ];

  time.timeZone = "Asia/Riyadh";
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [];

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
