{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.ollama;
in
{
  options.modules.server.ollama = lib.my.mkServerModule {
    name = "Ollama";
    subdomain = "ai";
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
