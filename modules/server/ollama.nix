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

    port = mkOption {
      type = types.int;
      default = 8814;
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
      loadModels = [ "deepseek-r1" ];
    };
    services.open-webui = {
      enable = true;
      port = cfg.port;
      environment = {
        OLLAMA_BASE_URL = "http://localhost:${cfg.port - 1000}";
        ENABLE_OPENAI_API = false;
      };
    };
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
