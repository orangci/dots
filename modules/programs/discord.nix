{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.programs.discord.enable = lib.mkEnableOption "enables discord";
  };
  config = lib.mkIf config.modules.programs.discord.enable {
    environment.systemPackages = with pkgs; [
      (pkgs.discord.override {
        withOpenASAR = true;
        withTTS = true;
        withVencord = true;
      })
    ];
  };
}
