{ config, lib, ... }:
let
  # every enabled mkServerModule service, as modules.services.<category>.<name>
  enabled = lib.concatMapAttrs (
    category:
    lib.concatMapAttrs (
      name: mod:
      lib.optionalAttrs (mod.enable or false && mod ? port && mod ? subdomain) {
        "${category}.${name}" = mod;
      }
    )
  ) config.modules.services;

  # attrset of value -> services using it, keeping only values used more than once
  clashes =
    attr:
    lib.filterAttrs (_: users: builtins.length users > 1) (
      builtins.groupBy (n: toString enabled.${n}.${attr}) (
        builtins.filter (n: enabled.${n}.${attr} != "") (builtins.attrNames enabled)
      )
    );

  mkAssertion = attr: {
    assertion = clashes attr == { };
    message = "These services share a ${attr}: ${
      lib.concatStringsSep "; " (
        lib.mapAttrsToList (value: users: "${value} (${lib.concatStringsSep ", " users})") (clashes attr)
      )
    }";
  };
in
{
  # derived ports (rcon at port - 1000 and so on) aren't covered, only the main ones
  assertions = map mkAssertion [
    "port"
    "subdomain"
  ];
}
