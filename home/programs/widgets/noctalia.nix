{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption singleton mkIf;
  cfg = config.hmModules.category.example;
  enablePlugin = {
    enable = true;
    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
  };
in
{
  imports = singleton inputs.noctalia.homeModules.default;
  options.hmModules.category.example = {
    enable = mkEnableOption "Noctalia shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gpu-screen-recorder ];
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
          file-search = config.programs.fd.enable;
          sys-info-widget = enablePlugin;
          privacy-indicator = enablePlugin;
          mawaqit = enablePlugin;
          dmenu = enablePlugin;
          ntfy-notifications = enablePlugin;
          keybind-cheatsheet = enablePlugin;
          timer = enablePlugin;
          kde-connect = config.services.kdeconnect.enable;
          polkit-agent = enablePlugin;
          custom-commands = enablePlugin;
          screen-recorder = enablePlugin;
        };
        version = 2;
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
