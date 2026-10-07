args@{
  inputs,
  pkgs,
  lib,
  system,
  flakeSettings,
  ...
}:
{
  docs = import ./docs.nix args;
  mudaremote = import ./mudaremote.nix args;
}
