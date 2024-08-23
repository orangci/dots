{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.category.name.enable =
      lib.mkEnableOption "enables name";
  };
  config = lib.mkIf config.modules.category.name.enable {
    option1.enable = true;

    environment.systemPackages = with pkgs; [hello];
  };
}
