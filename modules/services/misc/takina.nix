{
  config,
  lib,
  inputs,
  flakeSettings,
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
        PREFIX = ".";
        EMBED_COLOUR = "#FAB387";
        LIBRETRANSLATE_API_URL = "https://${config.modules.services.tools.libretranslate.subdomain}.${flakeSettings.domains.primary}";
        HASDB = "yes";
        EMOJIS_MODERATOR = "<:salute:1287038901151862795>";
        EMOJIS_NOTE = "<:note:1289880498541297685>";
        BOT_STATUS = "ROLLING BETA 2.0.0!!!";
        COGS_BLACKLIST = "core.settings";
        ENABLE_SESP_COGS = "yes";
      };
    };
  };
}
