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
    enable = mkEnableOption "Chromium";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPER, G, Launch Chromium, exec, chromium"
    ];
    wayland.windowManager.niri.settings.binds."Mod+G" = {
      _props.hotkey-overlay-title = "Launch Chromium";
      spawn = [ "chromium" ];
    };
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
