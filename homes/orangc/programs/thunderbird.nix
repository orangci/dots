{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
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
    profiles.${username} = {
      isDefault = true;
    };
  };
}
