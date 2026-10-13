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
      description = "Whether to declare a normal user account for every user listed in the host's `users.nix`.";
    };
    home-manager.autoDeclare = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to declare a home-manager configuration for every user listed in the host's `users.nix`, from `homes/USERNAME.nix`.";
    };
    home-manager.stateVersion = mkOption {
      type = types.str;
      default = "26.05";
      example = "25.11";
      description = "The `home.stateVersion` given to every automatically declared home-manager user on this machine. Like `system.stateVersion`, set it to the release you first installed with and leave it be.";
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
