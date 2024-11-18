{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.programs.thunar;
in {
  options.modules.programs.thunar = {
    enable = mkEnableOption "Enable thunar";
    archive-plugin.enable = mkEnableOption "Enable thunar's archive plugin";
  };

  config = lib.mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce;
        [
          thunar-volman
          thunar-media-tags-plugin
        ]
        ++ (lib.optionals cfg.archive-plugin.enable [
          thunar-archive-plugin
        ]);
    };
    nixpkgs.config.packageOverrides = pkgs: {
      xfce =
        pkgs.xfce
        // {
          inherit (pkgs) gvfs;
        };
    };
    environment.systemPackages = with pkgs; [xfce.tumbler];
    services.gvfs.enable = true;
  };
}
