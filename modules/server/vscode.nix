{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;

  cfg = config.modules.server.vscode;
in
{
  options.modules.server.vscode = {
    enable = mkEnableOption "Enable VSCode Server";

    name = mkOption {
      type = types.str;
      default = "VSCode Server";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for VSCode Server to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "code.orangc.net";
      description = "The domain for VSCode Server to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.vscode-server-connection-token = {
      path = "/var/secrets/vscode-server-connection-token";
      owner = username;
    };

    services.openvscode-server = {
      enable = true;
      port = cfg.port;

      # use your user home
      user = username;
      serverDataDir = "/home/${username}/.vscode-server";
      extensionsDir = "/home/${username}/.vscode-server/extensions";

      telemetryLevel = "crash";
      connectionTokenFile = config.modules.common.sops.secrets.vscode-server-connection-token.path;

      extraPackages = with pkgs; [ git nix ];
    };
  };
}
