{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.programs.chromium;
in {
  options.hmModules.programs.chromium = {
    enable = mkEnableOption "Enable Chromium";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = ["SUPER, G, exec, chromium"];
    programs.chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
        "hdpcadigjkbcpnlcpbcohpafiaefanki" # nightTab
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin Mocha
        "ibplnjkanclpjokhdolnendpplpjiace" # Simple Translate
      ];
    };
  };
}
