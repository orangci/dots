{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.dm.sddm;
in
{
  options.modules.dm.sddm = {
    enable = mkEnableOption "Enable SDDM";
    theme = lib.mkOption {
      type = lib.types.str;
      default = "tokyo-night";
      description = "The SDDM theme to use";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      let
        sddm-themes = pkgs.callPackage ./pkgs.nix { };
      in
      [
        sddm-themes.${cfg.theme}
        pkgs.libsForQt5.qt5.qtgraphicaleffects
      ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = cfg.theme;
    };
  };
}
