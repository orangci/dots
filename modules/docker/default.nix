# WIP
{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.modules.programs.docker;
in {
  options.modules.programs.docker = {
    enable = mkEnableOption "Enable Docker daemon and client";

    # Optionally allow configuring Docker package version
    package = mkOption {
      type = types.package;
      default = pkgs.docker;
      description = "Docker package to use";
    };

    extraOptions = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Extra options to add to the Docker daemon config.";
    };

    allowUnprivileged = mkOption {
      type = types.bool;
      default = false;
      description = "Allow unprivileged users to run Docker commands by adding them to 'docker' group";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    services.docker.enable = true;

    # Add extra options to the Docker daemon config (merged with defaults)
    services.docker.extraOptions = lib.mkForce (lib.attrsets.mergeDeepRight {
        # default options can go here if you want
      }
      cfg.extraOptions);

    # Add user to docker group if allowUnprivileged is true
    users.groups.docker = {
      name = "docker";
      extraMembers =
        if cfg.allowUnprivileged
        then [config.users.users.${username}.name]
        else [];
    };
  };
}
