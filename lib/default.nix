{ lib, flakeSettings }:

{
  mkServerModule = import ./mkServerModule.nix { inherit lib flakeSettings; };
  mkCaddyEntry = import ./mkCaddyEntry.nix { inherit lib flakeSettings; };
  mkCloudflaredIngress = import ./mkCloudflaredIngress.nix { inherit lib flakeSettings; };
}
