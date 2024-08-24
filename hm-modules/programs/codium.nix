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
      extensions = with pkgs; [
        vscode-extension-leonardssh-vscord
        vscode-extension-kamadorueda-alejandra
        vscode-extension-bradgashler-htmltagwrap
        vscode-extension-ecmel-vscode-html-css
        vscode-extension-ritwickdey-liveserver
      ];
    };
  };
}
