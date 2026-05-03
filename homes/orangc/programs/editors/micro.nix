{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkForce
    mkEnableOption
    mkIf
    singleton
    getExe
    ;
  cfg = config.hmModules.programs.editors.micro;
  plugins = {
    manipulator = pkgs.fetchFromGitHub {
      owner = "NicolaiSoeborg";
      repo = "manipulator-plugin";
      rev = "41ce0bebf29a6f36144dc9ecdd516a27b5b45b64";
      hash = "sha256-ucHOrZhmEVl+4J5q1vqytxrrMw6LXsoV7/nnAgdCQXo=";
    };
    wakatime = pkgs.fetchFromGitHub {
      owner = "wakatime";
      repo = "micro-wakatime";
      rev = "b01d137df0290b45ab4da72f99e3d01be8238674";
      hash = "sha256-jAYGq8CuYv5qeL3IuSgqXh//jcZZiFFxQSGsFU/u7qE=";
    };
    lsp = pkgs.fetchFromGitHub {
      owner = "AndCake";
      repo = "micro-plugin-lsp";
      rev = "a3ed3a73b2f7576b1e2dc1ac3c98dfe695e6d05d";
      hash = "sha256-0an688Bc+ZtJ4JHqMfD8UAsCoKgQs6A+DRgfr1QpYG0=";
    };
  };
in
{
  options.hmModules.programs.editors.micro.enable = mkEnableOption "Enable micro";

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "micro";
    programs.micro = {
      enable = true;
      settings = {
        colorscheme = mkForce "cmc-16";
        mkparents = true;
        softwrap = true;
        "lsp.server" = "nix=${getExe pkgs.nil}";
      };
    };
    home.file = lib.mapAttrs' (name: value: {
      name = "${config.xdg.configHome}/micro/plug/${name}";
      value = {
        source = value;
        recursive = true;
      };
    }) plugins;
  };
}
