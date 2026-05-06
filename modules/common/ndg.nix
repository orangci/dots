{
  config,
  lib,
  inputs,
  flakeSettings,
  system,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption my;
  cfg = config.modules.common.ndg;
  inherit (inputs.self.packages.${system}) docs;
in
{
  options.modules.common.ndg.enable = mkEnableOption "Enable ndg";
  config = mkIf cfg.enable {
    documentation.nixos.options.warningsAreErrors = false;
    environment.etc."flake-docs".source = docs.outPath;
    modules.server.cloudflared.ingress = my.mkCloudflaredIngress "flake" 3936;
    modules.server.caddy.virtualHosts = (my.mkCaddyEntry "flake" 3936 true) // {
      ":3936".extraConfig = ''
        root * /etc/flake-docs
        file_server
        header ?Cache-Control "max-age=1800"

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
