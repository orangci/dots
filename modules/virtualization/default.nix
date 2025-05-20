{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.virtualization;
in {
  options.modules.virtualization = {
    qemu = mkEnableOption "Enable QEMU user-mode emulation";

    libvirtd = {
      enable = mkEnableOption "Enable libvirtd daemon";
      group = lib.mkOption {
        type = lib.types.str;
        default = "libvirt";
        description = "Group that manages libvirt permissions";
      };
      listenTcp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether libvirtd should listen on TCP";
      };
    };
  };

  config = lib.mkMerge [
    (mkIf cfg.qemu {
      virtualisation.qemu.userModeNetworking = true;
      environment.systemPackages = [pkgs.qemu];
    })

    (mkIf cfg.libvirtd.enable {
      virtualisation.libvirtd.enable = true;
      virtualisation.libvirtd.group = cfg.libvirtd.group;
      virtualisation.libvirtd.listenTcp = cfg.libvirtd.listenTcp;
      environment.systemPackages = [pkgs.libvirt];
    })
  ];
}
