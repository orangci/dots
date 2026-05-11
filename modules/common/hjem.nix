{
  config,
  lib,
  inputs,
  users,
  ...
}:
let
  inherit (lib) mkEnableOption mkAliasOptionModule singleton;
  cfg = config.modules.common.hjem;
  excludedUsers = [ "sysadmin" ];
  filteredUsers = lib.filterAttrs (n: _: !(builtins.elem n excludedUsers)) users;
in
{
  imports = singleton (
    mkAliasOptionModule [ "hjem" "users" ] [ "hj" ]
  );
  options.modules.common.hjem.enable = mkEnableOption "Hjem, home-manager alternative";
  config = lib.mkIf cfg.enable {
    hjem = {
      clobberByDefault = true;
      extraModules = singleton inputs.hjem-rum.hjemModules.default;
      users = builtins.mapAttrs (name: _: {
        directory = "/home/${name}";
      }) filteredUsers;
    };
  };
}
