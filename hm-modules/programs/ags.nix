{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption types;
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  options.hmModules.programs.ags = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    home.packages = with pkgs; [
      bun
      dart-sass
      hyprpicker
      networkmanager
      bluez
      bluez-tools
    ];

    programs.ags = {
      enable = true;
      extraPackages = with pkgs; [accountsservice];
    };
  };
}
