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

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

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

    glance.icon = mkOption {
      type = types.str;
      default = "si:vscodium";
      description = "The icon for Glance";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.vscode-server-connection-token = {
      path = "/var/secrets/vscode-server-connection-token";
      owner = username;
    };

    services.openvscode-server = {
      enable = true;
      inherit (cfg) port;

      # use your user home
      user = username;
      serverDataDir = "/home/${username}/.vscode-server";
      extensionsDir = "/home/${username}/.vscode-server/extensions";

      telemetryLevel = "crash";
      connectionTokenFile = config.modules.common.sops.secrets.vscode-server-connection-token.path;

      extraPackages = with pkgs; [
        git
        nix
      ];
    };
  };
}
