{
  config,
  lib,
  inputs,
  flakeSettings,
  system,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.common.ndg;
  docs = inputs.self.packages.${system}.docs;
in
{
  options.modules.common.ndg.enable = mkEnableOption "Enable ndg";
  config = mkIf cfg.enable {
    documentation.nixos.options.warningsAreErrors = false;
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

        header { 
        Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate"   
        Pragma "no-cache"
        Expires "0"
        }
        
        @rootIndex path /index.html 
        redir @rootIndex / 301  
        @subIndex path */index.html
        redir @subIndex {path}/.. 301  
        @html path_regexp html ^(.+)\.html$  
        redir @html {re.html.1} 301 
        try_files {path} {path}.html {path}/index.html
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
