{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    modules.programs.minecraft.enable =
      lib.mkEnableOption "enables Minecraft";
  };
  config = lib.mkIf config.modules.programs.minecraft.enable {
    environment.systemPackages = with pkgs; [prismlauncher];
  };
}
