{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.codium = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        leonardssh.vscord # discord RPC
        kamadorueda.alejandra # nix formatter
        bradgashler.htmltagwrap # html tag wrapping
        ecmel.vscode-html-css # html & css formatting
        ritwickdey.liveserver # live server
      ];
    };
  };
}
