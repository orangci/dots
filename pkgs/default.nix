args@{
  inputs,
  pkgs,
  lib,
  system,
  flakeSettings,
}:
{
  docs = import ./docs.nix args;
}
