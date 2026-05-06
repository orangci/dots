{ lib, flakeSettings }:

{
  mkServerModule = import ./options/mkServerModule.nix { inherit lib flakeSettings; };
  mkCaddyEntry = import ./helpers/mkCaddyEntry.nix { inherit lib flakeSettings; };
  mkCloudflaredIngress = import ./helpers/mkCloudflaredIngress.nix { inherit lib flakeSettings; };
}
