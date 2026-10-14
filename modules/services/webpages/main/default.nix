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
    concatStringsSep
    concatMap
    ;
  cfg = config.modules.services.webpages.main;
in
{
  options.modules.services.webpages.main =
    lib.my.mkServerModule {
      name = "Webpagc";
      subdomain = "";
      glanceIcon = "https://${flakeSettings.domains.primary}/leaf.png";
      autoConfiguredServiceInfra = false;
    }
    // {
      redirects = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              sources = mkOption {
                type = types.listOf types.str;
                example = [
                  "g"
                  "git"
                ];
                description = "Paths, without the leading slash, that redirect to `target`. Anything below a path is redirected too, with the rest of the path appended to the target.";
              };
              target = mkOption {
                type = types.str;
                example = "https://git.orangc.net/c";
                description = "The URL to redirect to.";
              };
              code = mkOption {
                type = types.int;
                default = 301;
                description = "The HTTP status code of the redirect. Use 302 or 307 for a temporary redirect.";
              };
            };
          }
        );

        default = [ ];
        description = "Redirects served from the main domains. Other modules add to this, see `redirects.nix`.";
      };
    };

  config = mkIf cfg.enable {
    modules.services.infrastructure.caddy.virtualHosts = mkMerge [
      (lib.my.mkCaddyEntry "www" cfg.port false)
      {
        ${flakeSettings.domains.primary}.extraConfig = "reverse_proxy localhost:${toString cfg.port}";
        ${flakeSettings.domains.secondary}.extraConfig = "reverse_proxy localhost:${toString cfg.port}";
        ":${toString cfg.port}".extraConfig = ''
          root * /srv/webpagc
          # the build writes .br/.gz copies of every page, so serve those instead of compressing on the fly
          file_server {
              precompressed br gzip
          }
          header ?Cache-Control "max-age=1800"
          # these filenames contain a hash of their contents, so they can be cached forever
          @immutable path /_app/immutable/*
          header @immutable Cache-Control "public, max-age=31536000, immutable"

          # show the 404 page at the missing URL, with a real 404 status
          handle_errors 404 {
              rewrite * /404.html
              file_server {
                  precompressed br gzip
                  status 404
              }
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
              r:
              map (source: "handle_path /${source}/* { redir * ${r.target}{path} ${toString r.code} }") r.sources
            ) cfg.redirects
          )}
        '';
      }
    ];
    modules.services.infrastructure.cloudflared.ingress = mkMerge [
      (lib.my.mkCloudflaredIngress "www" cfg.port)
      {
        ${flakeSettings.domains.primary} = "http://localhost:${toString cfg.port}";
        ${flakeSettings.domains.secondary} = "http://localhost:${toString cfg.port}";
      }
    ];
    modules.services.monitoring.glance.monitoredSites = lib.singleton {
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
