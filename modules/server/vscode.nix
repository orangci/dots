{
  config,
  lib,
  pkgs,
  users,
  ...
}:

let
  inherit (lib)
    mkIf
    ;

  cfg = config.modules.server.vscode;
in
{
  options.modules.server.vscode = lib.my.mkServerModule {
    name = "VSCode Server";
    subdomain = "code";
    glanceIcon = "si:vscodium";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.vscode-server-connection-token = {
      path = "/var/secrets/vscode-server-connection-token";
      owner = users.sysadmin.username;
    };

    services.openvscode-server = {
      enable = true;
      inherit (cfg) port;

      # use your user home
      user = users.sysadmin.username;
      serverDataDir = "/home/${users.sysadmin.username}/.vscode-server";
      extensionsDir = "/home/${users.sysadmin.username}/.vscode-server/extensions";

      telemetryLevel = "crash";
      connectionTokenFile = config.modules.common.sops.secrets.vscode-server-connection-token.path;

      extraPackages = with pkgs; [
        git
        nix
        nixd
      ];
    };
  };
}
