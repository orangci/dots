{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf singleton mkEnableOption;
  cfg = config.modules.services.misc.takina;
in
{
  imports = singleton inputs.takina.nixosModules.default;
  options.modules.services.misc.takina = {
    enable = mkEnableOption "Takina Discord bot";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.takina-env.path = "/var/secrets/takina-env";
    services.takina = {
      enable = true;
      environmentFile = config.modules.security.sops.secrets.takina-env.path;
      config = {
        prefix = ".";
        embedColor = "#FAB387";
        libretranslateApiUrl = "http://localhost:${toString config.modules.services.tools.libretranslate.port}";
      };
    };
  };
}
