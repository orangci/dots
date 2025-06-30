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

    name = mkOption {
      type = types.str;
      default = "Ollama";
    };

    port = mkOption {
      type = types.port;
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
      port = (cfg.port - 1000);
      acceleration = false;
      loadModels = [ "gemma3" ];
    };
    services.open-webui = {
      enable = true;
      port = cfg.port;
      environment = {
        OLLAMA_BASE_URL = "http://localhost:${toString (cfg.port - 1000)}";
        ENABLE_OPENAI_API = "False";
      };
    };
  };
}
