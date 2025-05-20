{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf optional;
  cfg = config.hmModules.programs.discord;

  getDiscordPackage = client:
    if client == "equibop"
    then pkgs.equibop
    else if client == "vesktop"
    then pkgs.vesktop
    else if client == "webcord"
    then pkgs.webcord
    else
      pkgs.discord.override {
        withOpenASAR = true;
        withTTS = true;
        withVencord = true;
      };
in {
  options.hmModules.programs.discord = {
    enable = mkEnableOption "Install and configure a Discord client";
    arrpc = mkEnableOption "Enable Discord RPC via arrpc";

    client = mkOption {
      type = types.enum ["discord" "equibop" "vesktop" "webcord"];
      default = "discord";
      description = ''
        Which Discord client to install:
        - discord (with OpenASAR, TTS, and Vencord)
        - equibop
        - vesktop
        - webcord
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      [getDiscordPackage cfg.client]
      ++ optional cfg.arrpc pkgs.arrpc;

    home.file = {
      ".config/Vencord/themes/orangetweaks.css".source = ./vencordthemes/orangetweaks.css;
      ".config/Vencord/themes/catppuccin.css".source = ./vencordthemes/catppuccin.css;
      ".config/equibop/themes/orangetweaks.css".source = ./vencordthemes/orangetweaks.css;
      ".config/equibop/themes/catppuccin.css".source = ./vencordthemes/catppuccin.css;
    };
  };
}
