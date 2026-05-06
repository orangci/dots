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
          extraConfig = ''
            bind tailscale/${subdomain}
            reverse_proxy localhost:${toString port}
          '';
        };
      }
    else
      { };
in
baseEntries // tailnetEntry
