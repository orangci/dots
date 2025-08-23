{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkMerge
    ;
  cfg = config.hmModules.programs;
  colours = config.stylix.base16Scheme;
  inherit (config.stylix) fonts;
  base16-discord = pkgs.concatTextFile {
    name = "base16-discord.css";
    files = [
      "${
        pkgs.fetchFromGitHub {
          owner = "imbypass";
          repo = "base16-discord";
          rev = "main";
          sha256 = "sha256-aIHKXraupaT8IoUXfBLxRp9lx73wpVMYi2BTpixcWxg=";
        }
      }/base16.css"
      (builtins.toFile "base16.css" ''
        :root {
            --font: "${fonts.sansSerif.name}";
            --font-code: "${fonts.monospace.name}";
            --base00: ${colours.base00};
            --base01: ${colours.base01};
            --base02: ${colours.base02};
            --base03: ${colours.base03};
            --base04: ${colours.base04};
            --base05: ${colours.base05};
            --base06: ${colours.base06};
            --base07: ${colours.base07};
            --base08: ${colours.base08};
            --base09: ${colours.base09};
            --base0A: ${colours.base0A};
            --base0B: ${colours.base0B};
            --base0C: ${colours.base0C};
            --base0D: ${colours.base0D};
            --base0E: ${colours.base0E};
            --base0F: ${colours.base0F};
        }
      '')
    ];
  };

  getDiscordPackage =
    client:
    if client == "equibop" then
      pkgs.equibop
    else if client == "vesktop" then
      pkgs.vesktop
    else if client == "webcord" then
      pkgs.webcord
    else
      pkgs.discord.override {
        withOpenASAR = true;
        withTTS = true;
        withVencord = true;
      };
in
{
  options.hmModules.programs = {
    discord = {
      enable = mkEnableOption "Install and configure a Discord client";
      client = mkOption {
        type = types.enum [
          "discord"
          "equibop"
          "vesktop"
          "webcord"
        ];
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
    arrpc.enable = mkEnableOption "Enable Discord RPC via arrpc";
  };

  config = {
    wayland.windowManager.hyprland.settings.bindd = mkIf cfg.discord.enable [
      "SUPER, D, Open Discord, exec, ${cfg.discord.client}"
    ];
    home.packages = mkIf cfg.discord.enable [ (getDiscordPackage cfg.discord.client) ];
    wayland.windowManager.hyprland.settings.exec-once = mkIf cfg.arrpc.enable [
      "sleep 3; ${pkgs.arrpc}/bin/arrpc &"
    ];
    home.file = lib.mkIf cfg.discord.enable (
      lib.mkMerge [
        (lib.optional (cfg.discord.client != "equibop") {
          ".config/Vencord/themes/orangetweaks.css".source = ./vencordthemes/orangetweaks.css;
          ".config/Vencord/themes/base16.css".source = base16-discord;
        })
        (lib.optional (cfg.discord.client == "equibop") {
          ".config/equibop/themes/orangetweaks.css".source = ./vencordthemes/orangetweaks.css;
          ".config/equibop/themes/base16.css".source = base16-discord;
        })
      ]
    );
  };
}
