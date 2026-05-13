{
  pkgs,
  inputs,
  users,
  lib,
  ...
}:
let
  excludedUsers = [ "sysadmin" ];
  filteredUsers = lib.filterAttrs (n: _: !(builtins.elem n excludedUsers)) users;
in
{
  imports = [
    ./hardware.nix
    ../../modules
    inputs.home-manager.nixosModules.home-manager
  ];

  modules = {
    dm.sddm.enable = true;
    common = {
      bluetooth.enable = true;
      printing.enable = true;
      sound.enable = true;
      networking.enable = true;
      virtualisation.enable = false;
      sops.enable = false;
    };
    programs = {
      thunar.enable = true;
      hyprland.enable = true;
      appimages.enable = false;
      sudo-rs.enable = true;
    };
    gaming = {
      wine.enable = true;
      lutris.enable = true;
      bottles.enable = false;
      steam.enable = false;
      heroic.enable = false;
      minecraft = {
        enable = true;
        modrinth.enable = false;
        labymod.enable = true;
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
  services.tailscale.enable = true;

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "26.11";
  # networking.nameservers = lib.mkForce [ "192.168.8.191" ];
  hardware.logitech.wireless.enable = true;
  services.libinput.touchpad.sendEventsMode = "disabled";

  environment.systemPackages = with pkgs; [
    nh
    micro
    lxqt.lxqt-policykit
    nix-output-monitor
    libnotify
  ];

  users.users = builtins.mapAttrs (_: user: {
    home = "/home/${user.username}";
    homeMode = "755";
    isNormalUser = true;
    description = "${user.username}";
    initialPassword = "password";
    extraGroups = [
      "networkmanager"
      "scanner"
    ]
    ++ lib.optionals user.sudo [
      "wheel"
      "libvirtd"
      "lp"
      "docker"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  }) filteredUsers;

  home-manager.users = builtins.mapAttrs (_: user: {
    home = {
      inherit (user) username;
      homeDirectory = "/home/${user.username}";
      stateVersion = "26.05";
    };
    programs.home-manager.enable = true;
  }) filteredUsers;
}
