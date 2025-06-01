{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.browsers.chromium;
in
{
  options.hmModules.programs.browsers.chromium = {
    enable = mkEnableOption "Enable Chromium";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindd = [ "SUPER, G, Launch Chromium, exec, chromium" ];
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
