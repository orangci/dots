{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption singleton;
  cfg = config.modules.desktop.common;
in
{
  options.modules.desktop.common.enable =
    mkEnableOption "the bits every machine with a screen needs (keyring, polkit agent, boot splash and so on)";

  config = lib.mkIf cfg.enable {
    programs = {
      dconf.enable = true;
      seahorse.enable = true;
    };

    security = {
      rtkit.enable = true;
      # let logged in users reboot and power off without a password
      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };

    services = {
      xserver = {
        enable = false;
        xkb.layout = "us";
      };
      upower.enable = true;
      libinput.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    boot = {
      plymouth.enable = true;
      # virtual webcam, for OBS and friends
      kernelModules = singleton "v4l2loopback";
      extraModulePackages = singleton config.boot.kernelPackages.v4l2loopback;
    };

    environment.systemPackages = singleton pkgs.lxqt.lxqt-policykit;
  };
}
