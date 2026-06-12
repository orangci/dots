{
  config,
  lib,
  inputs,
  pkgs,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    types
    mkOption
    replaceStrings
    mkMerge
    my
    ;
  cfg = config.modules.services.gaming.minecraft.juniper-s11;
  packwiz = pkgs.fetchPackwizModpack {
    url = "https://git.orangc.net/c/minecraft-modpacks/raw/commit/062c447d7d065851cc59884b4a35523849929db9/juniper-s11/pack.toml";
    packHash = "sha256-LGYKPTF81wGwrsJTT/xpOaacOLUdWrhZdcDhCnTULS8=";
    # dummy: pkgs.lib.fakeHash
  };
in
{
  options.modules.services.gaming.minecraft.juniper-s11 = {
    enable = mkEnableOption "Enable Juniper SMP server";

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for Juniper to be hosted at";
    };

    minRAM = mkOption {
      type = types.int;
      default = 4;
      description = "Minimum amount of RAM for Juniper to use in gigabytes";
    };

    maxRAM = mkOption {
      type = types.int;
      default = 8;
      description = "Maximum amount of RAM for Juniper to use in gigabytes";
    };

    motd = mkOption {
      type = types.str;
      default = "Powered by NixOS!";
      description = "The message displayed in the server list of the client";
    };

    gamerules = mkOption {
      type = types.attrs;
      description = "Server gamerules";
      default = {
        commandBlockOutput = false;
        commandModificationBlockLimit = 1000;
        keepInventory = true;
      };
    };
  };

  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./utilities/automatic-backups.nix
  ];

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    # reverse proxying & cloudflared
    modules.services.infrastructure.caddy.virtualHosts = mkMerge [
      (my.mkCaddyEntry "mc-map" (cfg.port - 2000) false)
      (my.mkCaddyEntry "mc-dash" (cfg.port - 3000) false)
    ];
    modules.services.infrastructure.cloudflared.ingress = lib.mkMerge [
      (my.mkCloudflaredIngress "mc-map" (cfg.port - 2000))
      (my.mkCloudflaredIngress "mc-dash" (cfg.port - 3000))
      {
        "mc.${flakeSettings.domains.primary}" = "tcp://localhost:${toString cfg.port}";
        "mc.${flakeSettings.domains.secondary}" = "tcp://localhost:${toString cfg.port}";
      }
    ];

    # The two secrets below are required for the simple-discord-link mod to work properly
    modules.security.sops.secrets = {
      "juniper/bot-token" = {
        owner = "minecraft";
        path = "/var/secrets/juniper-bot-token";
      };
      "juniper/bot-client-id" = {
        owner = "minecraft";
        path = "/var/secrets/juniper-bot-client-id";
      };
      "juniper/bot-client-secret" = {
        owner = "minecraft";
        path = "/var/secrets/juniper-bot-client-secret";
      };
      "juniper/in-game-chat-webhook" = {
        owner = "minecraft";
        path = "/var/secrets/juniper-in-game-chat-webhook";
      };
    };

    services.minecraft-servers.servers.juniper = {
      enable = true;
      enableReload = true;
      autoStart = true;
      restart = "always";
      jvmOpts = "-Xms${toString cfg.minRAM}G -Xmx${toString cfg.maxRAM}G";
      package = pkgs.neoforgeServers.neoforge-1_21_1-21_1_233;

      symlinks = {
        "mods" = "${packwiz}/mods";
        "resources/datapack/required" = "${packwiz}/datapacks";
        "server-icon.png" = "${packwiz}/server-icon.png";
      };

      extraStartPre = ''
        # mods configs
        mkdir -p config
        if [ -d ${packwiz}/config ]; then
          cp -r --no-preserve=mode,ownership ${packwiz}/config/* config
        fi

        # simple-discord-link stuff
        sdlinkConfig="config/simple-discord-link/simple-discord-link.toml"
        webhook_url=$(cat ${config.modules.security.sops.secrets."juniper/in-game-chat-webhook".path})
        bot_token=$(cat ${config.modules.security.sops.secrets."juniper/bot-token".path})
        client_id=$(cat ${config.modules.security.sops.secrets."juniper/bot-client-id".path})
        client_secret=$(cat ${config.modules.security.sops.secrets."juniper/bot-client-secret".path})
        webhook_url_escaped=$(printf '%s\n' "$webhook_url" | sed -e 's/[\/&|]/\\&/g')
        bot_token_escaped=$(printf '%s\n' "$bot_token" | sed -e 's/[\/&|]/\\&/g')
        client_id_escaped=$(printf '%s\n' "$client_id" | sed -e 's/[\/&|]/\\&/g')
        client_secret_escaped=$(printf '%s\n' "$client_secret" | sed -e 's/[\/&|]/\\&/g')

        if [ -f "$sdlinkConfig" ]; then
          sed -i "s|REPLACE_WEBHOOK_URL|$webhook_url_escaped|g" "$sdlinkConfig"
          sed -i "s|REPLACE_BOT_TOKEN|$bot_token_escaped|g" "$sdlinkConfig"
        fi

        # neoessentials stuff
        neoessentialsConfig="config/neoessentials/config.json"
        neoessentialsDiscordConfig="config/neoessentials/discord_auth.json"

        if [ -f "$neoessentialsDiscordConfig" ]; then
          sed -i "s|REPLACE_CLIENT_ID|$client_id_escaped|g" "$neoessentialsDiscordConfig"
          sed -i "s|REPLACE_CLIENT_SECRET|$client_secret_escaped|g" "$neoessentialsDiscordConfig"
        fi

        if [ -f "$neoessentialsConfig" ]; then
          sed -i "s|REPLACE_NEOESSENTIALS_PORT|${toString (cfg.port - 3000)}|g" "$neoessentialsConfig"
        fi

        # squaremap port
        squaremapConfig="config/squaremap/config.yml"

        if [ -f "$squaremapConfig" ]; then
          sed -i "s|REPLACE_SQUAREMAP_PORT|${toString (cfg.port - 2000)}|g" "$squaremapConfig"
        fi
      '';

      # extraStartPost = concatStringsSep "\n" (
      # lib.mapAttrsToList (name: value: "gamerule ${name} ${toString value}") cfg.gamerules
      # );

    #  extraReload = ''
     #   ${pkgs.rconc}/bin/rconc jp "carpet customMOTD ${
      #    replaceStrings [ "\\n" ] [ "\n" ]
       #     config.services.minecraft-servers.servers.juniper.serverProperties.motd
      #  }"
     # '';

      operators = {
        orangci.uuid = "dde112e5-25c7-4963-800c-aa23c3816dbc";
        Ritorn77.uuid = "d167c6cf-6eaf-4a4f-a6b6-d332ac46de23";
        Banglider.uuid = "308ed3f5-8804-4ac0-914f-35c896bd4b10";
        Renzo738283.uuid = "91e23da3-716b-46e3-8f87-dd64da08be24";
        ElaineQheart.uuid = "f1c0c281-884b-40bd-bbd3-e750dc605cfa";
      };

      serverProperties = {
        motd = "§l  §r               §d§lJuniper §r— §a§lSeason XI§r\\n§l §b§o${cfg.motd}";
        level-seed = "Mystia's Izakaya.";
        difficulty = "hard";
        allow-nether = false;
        broadcast-console-to-ops = false;
        broadcast-rcon-to-ops = false;
        bug-report-link = "mailto:c@orangc.net";
        enable-command-block = true;
        enforce-secure-profile = false;
        enforce-whitelist = true;
        function-permission-level = 3;
        gamemode = "survival";
        max-players = 20;
        log-ips = false;
        max-world-size = 50000;
        online-mode = false;
        op-permission-level = 4;
        pause-when-empty-seconds = 300;
        player-idle-timeout = 0;
        pvp = true;
        enable-rcon = true;
        "rcon.password" = "@rcpwd@";
        "rcon.port" = cfg.port - 1000;
        server-name = "Juniper";
        server-port = cfg.port;
        simulation-distance = 8;
        spawn-protection = 0;
        view-distance = 16;
        white-list = false;
      };
    };
  };
}
