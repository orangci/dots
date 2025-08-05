{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    types
    mkOption
    concatStringsSep
    replaceStrings
    ;
  cfg = config.modules.server.minecraft.juniper-s10;
  packwiz = pkgs.fetchPackwizModpack {
    url = "https://github.com/orangci/minecraft-modpacks/raw/172c084008353bb76da7a3fed356518ae76cd114/juniper-s10/pack.toml";
    packHash = "sha256-I/DHasyp5jFK93EKp5LT3z/nWLEXFAWtZlKVnTmf8ZU=";
    # dummy: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
  };
in
{
  options.modules.server.minecraft.juniper-s10 = {
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
    # The two secrets below are required for the simple-discord-link mod to work properly
    modules.common.sops.secrets.juniper-discord-bot-token = {
      owner = "minecraft";
      path = "/var/secrets/juniper-discord-bot-token";
    };
    modules.common.sops.secrets.juniper-in-game-chat-webhook = {
      owner = "minecraft";
      path = "/var/secrets/juniper-in-game-chat-webhook";
    };
    services.minecraft-servers.servers.juniper = {
      enable = true;
      enableReload = true;
      autoStart = true;
      restart = "always";
      jvmOpts = "-Xms${toString cfg.minRAM}G -Xmx${toString cfg.maxRAM}G";
      # Update the loader version every now and then!
      # https://github.com/FabricMC/fabric-loader/releases
      # By removing the package override, the loader version will update automatically every flake update.
      # It's overridden now because changing the loader version occasionally breaks some mods...
      package = pkgs.fabricServers.fabric-1_21_7.override { loaderVersion = "0.16.14"; };

      symlinks = {
        "mods" = "${packwiz}/mods";
        "resources/datapack/required" = "${packwiz}/datapacks";
        "server-icon.png" = "${packwiz}/server-icon.png";
      };

      extraStartPre = ''
        # this is necessary so ledger works
        mkdir -p ledger

        # mods configs
        mkdir -p config
        if [ -d ${packwiz}/config ]; then
          cp -r --no-preserve=mode,ownership ${packwiz}/config/* config
        fi

        # simple-discord-link stuff
        sdlinkConfig="config/simple-discord-link/simple-discord-link.toml"
        webhook_url=$(cat ${config.modules.common.sops.secrets.juniper-in-game-chat-webhook.path})
        bot_token=$(cat ${config.modules.common.sops.secrets.juniper-discord-bot-token.path})
        webhook_url_escaped=$(printf '%s\n' "$webhook_url" | sed -e 's/[\/&|]/\\&/g')
        bot_token_escaped=$(printf '%s\n' "$bot_token" | sed -e 's/[\/&|]/\\&/g')

        if [ -f "$sdlinkConfig" ]; then
          sed -i "s|REPLACE_WEBHOOK_URL|$webhook_url_escaped|g" "$sdlinkConfig"
          sed -i "s|REPLACE_BOT_TOKEN|$bot_token_escaped|g" "$sdlinkConfig"
        fi

        # pl3xmap port
        pl3xmapConfig="config/pl3xmap/config.yml"

        if [ -f "$pl3xmapConfig" ]; then
          sed -i "s|REPLACE_PL3XMAP_PORT|${toString (cfg.port - 2000)}|g" "$pl3xmapConfig"
        fi

        # polymer port
        polymerConfig="config/polymer/auto-host.json"

        if [ -f "$polymerConfig" ]; then
          sed -i "s|REPLACE_POLYMER_PORT|${toString (cfg.port - 3000)}|g" "$polymerConfig"
        fi
      '';

      # extraStartPost = concatStringsSep "\n" (
      # lib.mapAttrsToList (name: value: "gamerule ${name} ${toString value}") cfg.gamerules
      # );

      extraReload = ''
        ${pkgs.rconc}/bin/rconc jp "carpet customMOTD ${
          replaceStrings [ "\\n" ] [ "\n" ]
            config.services.minecraft-servers.servers.juniper.serverProperties.motd
        }"
      '';

      # operators = {
        # orangci.uuid = "dde112e5-25c7-4963-800c-aa23c3816dbc";
        # Ritorn77.uuid = "d167c6cf-6eaf-4a4f-a6b6-d332ac46de23";
        # Banglider.uuid = "308ed3f5-8804-4ac0-914f-35c896bd4b10";
        # Renzo738283.uuid = "91e23da3-716b-46e3-8f87-dd64da08be24";
        # ElaineQheart.uuid = "f1c0c281-884b-40bd-bbd3-e750dc605cfa";
      # };

      serverProperties = {
        motd = "§l  §r                §d§lJuniper §r— §a§lSeason X§r\\n§l §b§o${cfg.motd}";
        level-seed = "888880777356331877";
        difficulty = "hard";
        allow-nether = true;
        broadcast-console-to-ops = false;
        broadcast-rcon-to-ops = false;
        bug-report-link = "https://orangc.net/gh/minecraft-modpacks/issues/new";
        enable-command-block = true;
        enforce-secure-profile = false;
        enforce-whitelist = true;
        function-permission-level = 3;
        gamemode = "survival";
        max-players = 20;
        log-ips = false;
        max-world-size = 50000;
        online-mode = true;
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
        spawn-protection = 16;
        view-distance = 16;
        white-list = false;
        require-resource-pack = true;
        resource-pack = "https://github.com/orangci/minecraft-modpacks/raw/refs/heads/master/juniper-s10/resourcepacks/pack.zip";
        resource-pack-prompt = "If you don't use the resourcepacks, fumos will burn down your house <3";
      };
    };
  };
}
