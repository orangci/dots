{
  config,
  lib,
  users,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.modules.programs.syncthing;
in
{
  options.modules.programs.syncthing.enable = mkEnableOption "Syncthing folder syncing";
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true; # only works for single-user machines btw
      guiAddress = "0.0.0.0:8384";
      # i don't actually want this to be declarative lol
      overrideFolders = false;
      overrideDevices = false;
      user = users.sysadmin.username;
      dataDir = "/home/${users.sysadmin.username}/.local/share/syncthing";
    };
  };
}
