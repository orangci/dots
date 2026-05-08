{ lib, flakeSettings, ... }:

subdomain: port:
let
  domains = lib.filter (d: d != "" && d != null) [
    flakeSettings.domains.primary
    flakeSettings.domains.secondary
  ];
in
lib.mkMerge (
  map (domain: {
    "${subdomain}.${domain}" = "http://localhost:${toString port}";
  }) domains
)
