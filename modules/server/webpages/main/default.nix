{
  config,
  lib,
  flakeSettings,
  inputs,
  system,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    mkMerge
    singleton
    concatStringsSep
    concatMap
    ;
  cfg = config.modules.server.webpages.main;
in
{
  imports = singleton ./redirects.nix;
  options.modules.server.webpages.main =
    lib.my.mkServerModule {
      name = "Webpagc";
      subdomain = "";
      glanceIcon = "https://${flakeSettings.domains.primary}/leaf.png";
    }
    // {
      redirects = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              sources = mkOption { type = types.listOf types.str; };
              target = mkOption { type = types.str; };
              code = mkOption {
                type = types.int;
                default = 301;
              };
            };
          }
        );

        default = [ ];
      };
    };

  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = mkMerge [
      (lib.my.mkCaddyEntry "www" cfg.port false)
      {
        ${flakeSettings.domains.primary}.extraConfig = "reverse_proxy localhost:${toString cfg.port}";
        ${flakeSettings.domains.secondary}.extraConfig = "reverse_proxy localhost:${toString cfg.port}";
        ":${toString cfg.port}".extraConfig = ''
          root * /srv/webpagc
          file_server
          header ?Cache-Control "max-age=1800"

          handle_errors {
              @404 expression {http.error.status_code} == 404
              rewrite @404 /404.html
              file_server
          }

          @rootIndex path /index.html 
          redir @rootIndex / 301  
          @subIndex path */index.html
          redir @subIndex {path}/.. 301 
          @html path_regexp html ^(.+)\.html$  
          redir @html {re.html.1} 301 
          try_files {path} {path}.html {path}/index.html
          ${concatStringsSep "\n" (
            concatMap (
              r: map (source: "redir /${source} ${r.target} ${toString r.code}") r.sources
            ) cfg.redirects
          )}
          ${concatStringsSep "\n" (
            concatMap (
              r: map (source: "handle_path /${source}/* { redir ${r.target}{path} ${toString r.code} }") r.sources
            ) cfg.redirects
          )}
        '';
      }
    ];
    modules.server.cloudflared.ingress = mkMerge [
      (lib.my.mkCloudflaredIngress "www" cfg.port)
      {
        ${flakeSettings.domains.primary} = "http://localhost:${toString cfg.port}";
        ${flakeSettings.domains.secondary} = "http://localhost:${toString cfg.port}";
      }
    ];
    modules.server.glance.monitoredSites = singleton {
      url = "https://${flakeSettings.domains.primary}";
      title = cfg.name;
      inherit (cfg.glance) icon;
    };
    systemd.tmpfiles.settings."10-webpagc"."/srv/webpagc"."L+" = {
      argument = inputs.webpagc.packages.${system}.default.outPath;
      user = "root";
      mode = "0755";
    };
  };
}
