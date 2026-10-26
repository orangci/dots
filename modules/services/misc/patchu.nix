{
  config,
  lib,
  inputs,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    singleton
    concatMap
    concatStringsSep
    attrValues
    filter
    intersectLists
    mapAttrsToList
    ;
  cfg = config.modules.services.misc.patchu;
  inherit (config.modules.services) webpages;
  inherit (flakeSettings.domains) primary secondary;

  collections = {
    memes = {
      root = "/srv/files/media/memes";
      prefix = "m";
    };
    art = {
      root = "/srv/files/media/art";
      prefix = "a";
    };
  };

  prefixes = filter (p: p != null) (map (c: c.prefix or null) (attrValues collections));
  redirectSources = concatMap (r: r.sources) webpages.main.redirects;
  paths = concatStringsSep " " (
    concatMap (p: [
      "/${p}"
      "/${p}/*"
    ]) prefixes
  );
in
{
  imports = singleton inputs.patchu.nixosModules.default;
  # the manager is patchu.<primary> alone, and the collections live under the main site's
  # domains, so caddy and cloudflared are wired by hand below
  options.modules.services.misc.patchu = lib.my.mkServerModule {
    name = "Patchu";
    glanceIcon = "mdi:bookshelf";
    autoConfiguredServiceInfra = false;
  };

  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = intersectLists prefixes redirectSources == [ ];
      message = "patchu: the prefixes ${toString (intersectLists prefixes redirectSources)} are also short links in the webpage's redirects.toml.";
    };

    # PATCHU_OIDC_{ISSUER,CLIENT_ID,CLIENT_SECRET,SUBJECT}, PATCHU_CF_{ZONE_ID,API_TOKEN}
    modules.security.sops.secrets.patchu-env.path = "/var/secrets/patchu-env";

    services.patchu = {
      enable = true;
      inherit (cfg) port;
      inherit collections;
      publicURL = "https://${secondary}";
      adminHost = "${cfg.subdomain}.${primary}";
      environmentFile = config.modules.security.sops.secrets.patchu-env.path;
      # copyparty writes to the same folders, and the setgid roots below keep them both in its group
      extraGroups = singleton "copyparty";
    };

    systemd.tmpfiles.rules = mapAttrsToList (
      _: c: "d ${c.root} 2775 copyparty copyparty -"
    ) collections;

    # the collections ride on the main site, which cloudflared already sends to caddy. only
    # orang.ci serves them, since purges only reach orang.ci urls; the primary domain sends
    # visitors there
    services.caddy.virtualHosts.":${toString webpages.main.port}".extraConfig = ''
      @patchu path ${paths}
      handle @patchu {
        @canonical host ${secondary}
        handle @canonical {
          reverse_proxy localhost:${toString cfg.port}
        }
        handle {
          redir https://${secondary}{uri} 301
        }
      }
    '';

    modules.services.infrastructure.caddy.virtualHosts."${cfg.subdomain}.${primary}".extraConfig =
      "reverse_proxy localhost:${toString cfg.port}";
    modules.services.infrastructure.cloudflared.ingress."${cfg.subdomain}.${primary}" =
      "http://localhost:${toString cfg.port}";

    modules.services.monitoring.glance.monitoredSites = mkIf cfg.glance.enable (singleton {
      url = "https://${cfg.subdomain}.${primary}";
      title = cfg.name;
      inherit (cfg.glance) icon;
    });

    # the database; tags and metadata are also exported beside each collection, under /srv/files
    modules.security.restic.paths = singleton "/var/lib/patchu";
  };
}
