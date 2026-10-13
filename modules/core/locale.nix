{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.core.locale;
in
{
  options.modules.core.locale = lib.mkOption {
    type = lib.types.str;
    default = "en_GB.UTF-8";
    example = "en_US.UTF-8";
    description = "The locale used for the system language and for every `LC_*` category (dates, currency, measurements and so on).";
  };

  config = {
    i18n.defaultLocale = cfg;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg;
      LC_IDENTIFICATION = cfg;
      LC_MEASUREMENT = cfg;
      LC_MONETARY = cfg;
      LC_NAME = cfg;
      LC_NUMERIC = cfg;
      LC_PAPER = cfg;
      LC_TELEPHONE = cfg;
      LC_TIME = cfg;
    };
  };
}
