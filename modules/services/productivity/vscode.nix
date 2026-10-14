{
  config,
  lib,
  pkgs,
  sysadmin,
  ...
}:

let
  inherit (lib)
    mkIf
    ;

  cfg = config.modules.services.productivity.vscode;
in
{
  options.modules.services.productivity.vscode = lib.my.mkServerModule {
    name = "VSCode Server";
    subdomain = "code";
    glanceIcon = "si:vscodium";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.vscode-server-connection-token = {
      path = "/var/secrets/vscode-server-connection-token";
      owner = sysadmin.username;
    };

    services.openvscode-server = {
      enable = true;
      inherit (cfg) port;

      # use your user home
      user = sysadmin.username;
      serverDataDir = "/home/${sysadmin.username}/.vscode-server";
      extensionsDir = "/home/${sysadmin.username}/.vscode-server/extensions";

      telemetryLevel = "crash";
      connectionTokenFile = config.modules.security.sops.secrets.vscode-server-connection-token.path;

      extraPackages = with pkgs; [
        git
        nix
        nixd
      ];
    };
  };
}
