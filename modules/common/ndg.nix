{
  config,
  lib,
  inputs,
  flakeSettings,
  system,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.common.ndg;

  docs = inputs.ndg.packages.${system}.ndg-builder.override {
    title = "orangc's Flake Documentation";
    optionsDepth = 30;
    rawModules = lib.singleton config.modules;
  };
in
{
  options.modules.common.ndg.enable = mkEnableOption "Enable ndg";
  config = mkIf cfg.enable {
    environment.etc."flake-docs".source = docs.outPath;
    modules.server.cloudflared.ingress."flake.${flakeSettings.domains.primary}" =
      mkIf config.modules.server.cloudflared.enable "http://localhost:3936";
    modules.server.caddy.virtualHosts = mkIf config.modules.server.caddy.enable {
      "flake.${flakeSettings.domains.primary}".extraConfig = "reverse_proxy localhost:3936";
      "https://flake.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/flake
        reverse_proxy localhost:3936
      '';
      ":3936".extraConfig = ''
        root * /etc/flake-docs
        file_server
      '';
    };
    modules.server.glance.monitoredSites = mkIf config.modules.server.glance.enable [
      {
        url = "https://flake.${flakeSettings.domains.tailnet}";
        title = "Flake Documentation";
        icon = "sh:nixos";
      }
    ];
  };
}
