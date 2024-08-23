{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.programs.thunar.enable =
      lib.mkEnableOption "enables thunar";
  };
  config = lib.mkIf config.modules.programs.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
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
