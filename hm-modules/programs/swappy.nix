{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.swappy = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.packages = [pkgs.swappy];
    home.file.".config/swappy/config".text = ''
      [Default]
      save_dir=/home/${username}/media/screenshots
      save_filename_format=%M %d-%H.%M.%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=Raleway
      paint_mode=brush
      early_exit=true
      fill_shape=false
    '';
  };
}
