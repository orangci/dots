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
    inputs.home-manager.nixosModules.home-manager
  ]
  ++ lib.my.recursivelyImport [ ../../modules ];

  modules = {
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
  };

  services.tailscale.enable = true;

  time.timeZone = "Asia/Riyadh";
  system.stateVersion = "26.11";
  # networking.nameservers = lib.mkForce [ "192.168.8.191" ];
  hardware.logitech.wireless.enable = true;

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
      stateVersion = "25.05";
    };
    programs.home-manager.enable = true;
  }) filteredUsers;
}
