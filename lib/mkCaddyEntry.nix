{ lib, flakeSettings, ... }:

subdomain: port: enableTailnet:
let
  domains = lib.filter (d: d != "" && d != null) [
    flakeSettings.domains.primary
    flakeSettings.domains.secondary
  ];

  baseEntries = lib.mkMerge (
    map (domain: {
      "${subdomain}.${domain}" = {
        extraConfig = lib.mkDefault "reverse_proxy localhost:${toString port}";
      };
    }) domains
  );

  tailnetEntry =
    if
      enableTailnet && flakeSettings.domains.tailnet != null && flakeSettings.domains.tailnet != ""
    then
      {
        "https://${subdomain}.${flakeSettings.domains.tailnet}" = {
          # the global acme_dns makes caddy skip its implicit tailscale cert manager
          extraConfig = ''
            bind tailscale/${subdomain}
            tls {
              get_certificate tailscale
            }
            reverse_proxy localhost:${toString port}
          '';
        };
      }
    else
      { };
in
lib.mkMerge [
  baseEntries
  tailnetEntry
]
