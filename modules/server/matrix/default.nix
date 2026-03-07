{ lib, ... }:
{
  options.modules.server.matrix.enable = lib.mkEnableOption "Enable Matrix";
  imports = [
    ./synapse.nix
  ];
}
