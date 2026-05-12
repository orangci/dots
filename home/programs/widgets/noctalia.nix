{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption singleton mkIf;
  cfg = config.hmModules.programs.widgets.noctalia;
  enablePlugin = {
    enable = true;
    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
  };
in
{
  imports = singleton inputs.noctalia.homeModules.default;
  options.hmModules.programs.widgets.noctalia = {
    enable = mkEnableOption "Noctalia shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gpu-screen-recorder ];
    wayland.windowManager.hyprland.settings = {
      exec-once = singleton "noctalia-shell";
    };
    programs.noctalia-shell = {
      enable = true;
      plugins = {
        sources = singleton {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        states = {
          tailscale = enablePlugin;
          catwalk = enablePlugin;
          web-search = enablePlugin;
          currency-exchange = enablePlugin;
          usb-drive-manager = enablePlugin;
          workspace-overview = enablePlugin;
          file-search = mkIf config.programs.fd.enable enablePlugin;
          sys-info-widget = enablePlugin;
          privacy-indicator = enablePlugin;
          mawaqit = enablePlugin;
          dmenu = enablePlugin;
          ntfy-notifications = enablePlugin;
          keybind-cheatsheet = enablePlugin;
          timer = enablePlugin;
          kde-connect = mkIf config.services.kdeconnect.enable enablePlugin;
          polkit-agent = enablePlugin;
          custom-commands = enablePlugin;
          screen-recorder = enablePlugin;
        };
        version = 4;
      };

      pluginSettings = {
        catwalk = {
          minimumThreshold = 25;
          hideBackground = true;
        };
      };
    };
  };
}
