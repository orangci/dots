{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = [
    (import ../../scripts/rofi/calc.nix {inherit pkgs;})
    (import ../../scripts/rofi/emoji.nix {inherit pkgs;})
    (import ../../scripts/rofi/prism.nix {inherit pkgs;})
    (import ../../scripts/rofi/wall-select.nix {inherit pkgs;})
    (import ../../scripts/rofi/websearch.nix {inherit pkgs;})
    (import ../../scripts/list-bindings.nix {inherit pkgs;})
    (import ../../scripts/logout-exit.nix {inherit pkgs;})
    (import ../../scripts/screenrec.nix {inherit pkgs;})
    (import ../../scripts/walls.nix {inherit pkgs;})
  ];
}
