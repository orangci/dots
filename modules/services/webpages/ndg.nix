{
  config,
  lib,
  inputs,
  flakeSettings,
  system,
  ...
}:
let
  inherit (lib) mkIf my;
  cfg = config.modules.webpages.ndg;
  inherit (inputs.self.packages.${system}) docs;
in
{
  options.modules.webpages.ndg.enable = my.mkServerModule {
    name = "Flake Documentation";
    glanceIcon = "sh:nixos";
  };
  config = mkIf cfg.enable {
    documentation.nixos.options.warningsAreErrors = false;
    environment.etc."flake-docs".source = docs.outPath;
    modules.services.infrastructure.caddy.virtualHosts.":${cfg.port}".extraConfig = ''
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
}
