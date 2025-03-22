{
  config,
  pkgs,
  lib,
  ...
}: let
  getDiscordPackage = enable:
    if enable == "equibop"
    then pkgs.equibop
    else if enable == "vesktop"
    then pkgs.vesktop
    else if enable == "webcord"
    then pkgs.webcord
    else if enable == "none"
    then pkgs.hello
    else
      pkgs.discord.override {
        withOpenASAR = true;
        withTTS = true;
        withVencord = true;
      };
in {
  options.modules.programs.discord.enable = lib.mkOption {
    type = lib.types.str;
    default = "none";
    description = "Specify the Discord package to use.";
  };

  config = let
    discordPackage =
      if config.modules.programs.discord.enable != null
      then getDiscordPackage config.modules.programs.discord.enable
      else null;
  in {
    environment.systemPackages = lib.optionalAttrs (discordPackage != null) [
      discordPackage
      pkgs.arrpc
    ];
  };
}
