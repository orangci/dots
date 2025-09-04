{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.widgets.ignis;
in
{
  options.hmModules.programs.widgets.ignis = {
    enable = mkEnableOption "Enable ignis";
  };

  imports = [ inputs.ignis.homeManagerModules.default ];
  config = mkIf cfg.enable {
    programs.ignis = {
      enable = true;
      # addToPythonEnv = true;
      services = {
        bluetooth.enable = true;
        recorder.enable = true;
        audio.enable = true;
        network.enable = true;
      };

      sass = {
        enable = true;
        useDartSass = true;
      };

      extraPackages = with pkgs; [
        gnome-bluetooth
        matugen
        swww
        material-symbols
      ];
    };
  };
}
