{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.desktop.file-managers.thunar;
in
{
  options.modules.desktop.file-managers.thunar = {
    enable = mkEnableOption "Enable thunar";
    archive-plugin.enable = mkEnableOption "Enable thunar's archive plugin";
  };

  config = lib.mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins =
        with pkgs;
        [
          thunar-volman
          thunar-media-tags-plugin
        ]
        ++ (lib.optionals cfg.archive-plugin.enable [
          thunar-archive-plugin
        ]);
    };
    nixpkgs.config.packageOverrides = pkgs: {
      xfce = pkgs.xfce // {
        inherit (pkgs) gvfs;
      };
    };
    environment.systemPackages = [ pkgs.tumbler ];
    services.gvfs.enable = true;
  };
}
