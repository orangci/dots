{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.ollama;
in
{
  options.modules.server.ollama = {
    enable = mkEnableOption "Enable ollama";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    httpHome.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Ollama";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for ollama to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "ai.orangc.net";
      description = "The domain for ollama be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      port = cfg.port - 1000;
      acceleration = false;
      loadModels = [ "gemma3" ];
    };
    services.open-webui = {
      enable = true;
      inherit (cfg) port;
      environment = {
        OLLAMA_BASE_URL = "http://localhost:${toString (cfg.port - 1000)}";
        ENABLE_OPENAI_API = "False";
      };
    };
  };
}
