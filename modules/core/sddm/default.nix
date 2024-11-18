{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.dm.sddm;
in {
  options.modules.dm.sddm = {
    enable = mkEnableOption "Enable SDDM";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = let
      sddm-themes = pkgs.callPackage ./pkgs.nix {};
    in [
      # sddm-themes.sugar-dark
      # sddm-themes.tokyo-night
      sddm-themes.astronaut
    ];

    services.displayManager.sddm = {
      enable = true; # Enable SDDM.
      wayland.enable = true;
      theme = "astronaut";
    };
  };
}
