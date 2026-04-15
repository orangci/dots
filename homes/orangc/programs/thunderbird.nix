{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.hmModules.programs.thunderbird;
in
{
  options.hmModules.programs.thunderbird = {
    enable = mkEnableOption "Enable the thunderbird module";
  };

  config.programs.thunderbird = mkIf cfg.enable {
    # https://home-manager-options.extranix.com/?query=programs.thunderbird.&release=master
    enable = true;
    profiles.${flakeSettings.username} = {
      isDefault = true;
    };
  };
}
