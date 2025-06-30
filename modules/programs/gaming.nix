{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.gaming;

  gamingPackages =
    with pkgs;
    [ ] # Conditionally include packages based on options
    ++ (lib.optionals cfg.wine.enable [
      wineWow64Packages.wayland
      winetricks
      protontricks
    ])
    ++ (lib.optionals cfg.lutris.enable [ lutris ])
    ++ (lib.optionals cfg.bottles.enable [ bottles ])
    ++ (lib.optionals cfg.minecraft.enable [
      packwiz
      (prismlauncher.override {
        jdks = [
          zulu8
          zulu17
          zulu21
        ];
      })
    ])
    ++ (lib.optionals cfg.minecraft.modrinth.enable [ modrinth-app ]);
in
{
  options = {
    modules.gaming = {
      wine.enable = mkEnableOption "Enable Wine and associated packages for gaming";
      lutris.enable = mkEnableOption "Enable Lutris for gaming";
      bottles.enable = mkEnableOption "Enable Bottles for gaming";
      steam.enable = mkEnableOption "Enable Steam";
      minecraft = {
        enable = mkEnableOption "Enable PrismLauncher for Minecraft";
        modrinth.enable = mkEnableOption "Enable Modrinth Launcher for Minecraft";
      };
    };
  };

  config = {
    environment.systemPackages = gamingPackages;
    programs.steam = lib.mkIf cfg.steam.enable {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
