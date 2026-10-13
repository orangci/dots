{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    my
    mkMerge
    ;
  cfg = config.modules.services.webpages.notes;
in
{
  options.modules.services.webpages.notes = lib.my.mkServerModule {
    name = "Blog";
    subdomain = "notes";
    autoConfiguredServiceInfra = false;
  };

  config = mkIf cfg.enable {
    modules.services = {
      infrastructure.caddy.virtualHosts = mkMerge [
        (my.mkCaddyEntry "blog" cfg.port false)
        (my.mkCaddyEntry "notes" cfg.port false)
        {
          ":${toString cfg.port}".extraConfig = ''
            redir /rss.xml https://${flakeSettings.domains.primary}/rss.xml 301
            @post path_regexp post ^/notes/([^/]+?)(\.html)?/?$
            redir @post https://${flakeSettings.domains.primary}/notes/{re.post.1} 301
            redir https://${flakeSettings.domains.primary}/notes 301
          '';
        }
      ];
      infrastructure.cloudflared.ingress = mkMerge [
        (my.mkCloudflaredIngress "blog" cfg.port)
        (my.mkCloudflaredIngress "notes" cfg.port)
      ];
    };
  };
}
