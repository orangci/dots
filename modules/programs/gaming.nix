{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;
  cfg = config.modules.gaming;

  gamingPackages =
    with pkgs;
    [ ] # Conditionally include packages based on options
    ++ (optionals cfg.wine.enable [
      wineWow64Packages.wayland
      winetricks
      protontricks
    ])
    ++ (optionals cfg.lutris.enable [ lutris ])
    ++ (optionals cfg.bottles.enable [ bottles ])
    ++ (optionals cfg.heroic.enable [ heroic ])
    ++ (optionals cfg.osu.enable [ inputs.nix-gaming.packages.${pkgs.system}.osu-stable ])
    ++ (optionals cfg.minecraft.enable [
      packwiz
      (prismlauncher.override {
        jdks = [
          # Before 1.17: Java 8
          # 1.17: Java 16
          # 1.18 to 1.20: Java 17
          # 1.21: Java 21
          temurin-jre-bin-8
          temurin-jre-bin-24
        ];
      })
    ])
    ++ (optionals cfg.minecraft.modrinth.enable [ modrinth-app ]);
in
{
  imports = [ inputs.aagl.nixosModules.default ];
  options = {
    modules.gaming = {
      wine.enable = mkEnableOption "Enable Wine and associated packages for gaming";
      lutris.enable = mkEnableOption "Enable Lutris for gaming";
      bottles.enable = mkEnableOption "Enable Bottles for gaming";
      steam.enable = mkEnableOption "Enable Steam";
      heroic.enable = mkEnableOption "Enable Heroic Launcher";
      osu.enable = mkEnableOption "Enable Osu!";
      hoyoverse = {
        enable = mkEnableOption "Enable An Anime Game Launcher";
        genshin.enable = mkEnableOption "Enable Genshin Impact";
        honkai.enable = mkEnableOption "Enable Honkai Impact";
        zzz.enable = mkEnableOption "Enable Zenless Zone Zero";
      };
      minecraft = {
        enable = mkEnableOption "Enable PrismLauncher for Minecraft";
        modrinth.enable = mkEnableOption "Enable Modrinth Launcher for Minecraft";
      };
    };
  };

  config = {
    environment.systemPackages = gamingPackages;
    nix.settings = mkIf cfg.hoyoverse.enable inputs.aagl.nixConfig;
    programs = {
      anime-game-launcher.enable = cfg.hoyoverse.genshin.enable;
      honkers-launcher.enable = cfg.hoyoverse.honkai.enable;
      sleepy-launcher.enable = cfg.hoyoverse.zzz.enable;
      steam = mkIf cfg.steam.enable {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
    };
  };
}
