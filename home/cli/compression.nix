{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.compression;
in
{
  options.hmModules.cli.compression = {
    enable = mkEnableOption "compression CLI utilities";
    zip = mkEnableOption "zip and unzip";
    winrar = mkEnableOption "unar, for extracting RAR archives";
    gui = mkEnableOption "the file-roller archive manager GUI";
  };

  config = mkIf cfg.enable (
    lib.mkMerge [
      {
        hmModules.cli.shell.extraAliases = {
          mktar = "tar -czvf";
          extar = "tar -xzvf";
        };
      }

      (mkIf cfg.zip {
        home.packages = with pkgs; [
          zip
          unzip
        ];
      })

      (mkIf cfg.winrar {
        home.packages = with pkgs; [ unar ];
      })

      (mkIf cfg.gui {
        home.packages = with pkgs; [ file-roller ];
      })
    ]
  );
}
