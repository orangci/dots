{ pkgs
, config
, lib
, ...
}: {
  options = {
    modules.dm.sddm.enable =
      lib.mkEnableOption "enables sddm";
  };
  config = lib.mkIf config.modules.dm.sddm.enable {
    environment.systemPackages =
      let
        sddm-themes = pkgs.callPackage ./pkgs.nix { };
      in
      [
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
