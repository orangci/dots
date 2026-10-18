args@{
  inputs,
  pkgs,
  lib,
  system,
  flakeSettings,
  ...
}:
{
  docs = import ./docs args;
  mudaremote = import ./mudaremote.nix args;
}
