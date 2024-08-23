{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    (import ../../scripts/rofi/calc.nix {inherit pkgs;})
    (import ../../scripts/logout-exit.nix {inherit pkgs;})
    inputs.nixvim.packages.${pkgs.system}.default
  ];
}
