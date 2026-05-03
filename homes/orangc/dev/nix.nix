{
  config,
  lib,
  pkgs,
  inputs,
  host,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.dev.nix;
in
{
  imports = lib.singleton inputs.nix-index-database.homeModules.default;
  options.hmModules.dev.nix = {
    enable = mkEnableOption "Enable Nix development environment";
  };

  config = mkIf cfg.enable {
    programs = {
      nix-your-shell.enable = true;
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
    };
    home.packages = with pkgs; [
      nixfmt
      nix-prefetch
      nix-prefetch-github
      compose2nix
      deadnix
      statix
      nix-init
      nix-tree
      nil
    ];
    hmModules.cli.shell.extraAliases = {
      list-big-pkgs = "nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n 30";
      list-pkgs = "nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq";
      qn = "clear;nix-shell";
      nr = "nix repl --expr 'builtins.getFlake (toString ./.)'";
      nrr = "nixos-rebuild repl --flake .#${host}";
    };
  };
}
