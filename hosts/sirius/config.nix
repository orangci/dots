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
    dm.sddm.enable = true;
    common = {
      bluetooth.enable = true;
      printing.enable = false;
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

  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 8 * 1024; # 8GB
  #   }
  # ];

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "25.05";
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    nh
    micro
    lxqt.lxqt-policykit
    nix-output-monitor
    libnotify
  ];

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
