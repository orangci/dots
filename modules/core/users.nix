{
  config,
  lib,
  users,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  inherit (builtins) mapAttrs;
  cfg = config.modules.core.users;
  excludedUsers = [ "sysadmin" ];
  filteredUsers = lib.filterAttrs (n: _: !(builtins.elem n excludedUsers)) users;
in
{
  options.modules.core.users = {
    autoDeclare = mkOption {
      type = types.bool;
      default = true;
      description = "automatic declaration of user accounts";
    };
    home-manager.autoDeclare = mkOption {
      type = types.bool;
      default = true;
      description = "automatic declaration of home-manager users";
    };
    home-manager.stateVersion = mkOption {
      type = types.str;
      default = "26.05";
      description = "The state version of home-manager to use for all automatically declared users on this machine";
    };
  };

  config = {
    users.users = mkIf cfg.autoDeclare (
      mapAttrs (name: user: {
        home = "/home/${name}";
        homeMode = "755";
        isNormalUser = true;
        description = "${name}";
        initialPassword = "password";
        extraGroups = [
          "networkmanager"
          "scanner"
        ]
        ++ lib.optionals user.sudo [
          "wheel"
          "libvirtd"
          "lp"
          "docker"
        ];
        shell = pkgs.fish;
        ignoreShellProgramCheck = true;
      }) filteredUsers
    );
    home-manager.users = mkIf cfg.home-manager.autoDeclare (
      mapAttrs (name: _user: {
        home = {
          username = name;
          homeDirectory = "/home/${name}";
          inherit (cfg.home-manager) stateVersion;
        };
        programs.home-manager.enable = true;
      }) filteredUsers
    );
  };
}
