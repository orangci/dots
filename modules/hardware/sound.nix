{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.modules.hardware.sound.enable = lib.mkEnableOption "sound with pipewire";
  config = lib.mkIf config.modules.hardware.sound.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
        extraConfig."10-disable-camera"."wireplumber.profiles".main."monitor.libcamera" = "disabled";
      };
    };

    environment.systemPackages = with pkgs; [
      playerctl
      pavucontrol
    ];
  };
}
