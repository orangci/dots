{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.hyprlock = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.packages = [pkgs.hyprlock];
    home.file.".config/hypr/hyprlock.conf".text = ''source = ~/dots/hm-modules/programs/hyprland/hyprlock.conf'';
  };
}
