{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
    hyprpicker
    networkmanager
    # gtk3
    bluez
    bluez-tools
  ];

  programs.ags = {
    enable = true;
    # configDir = ./ags-aylur;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
