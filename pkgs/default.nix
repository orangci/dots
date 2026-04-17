{
  inputs,
  pkgs,
  lib,
  system,
}:
{
  docs = import ./docs.nix {
    inherit
      inputs
      pkgs
      lib
      system
      ;
  };
}
