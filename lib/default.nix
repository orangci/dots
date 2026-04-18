{ lib, flakeSettings }:

{
  mkServerModule = import ./options/server-modules.nix { inherit lib flakeSettings; };
}
