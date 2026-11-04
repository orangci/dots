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
    ;
  cfg = config.modules.services.gaming.minecraft.feysac;
  packwiz = pkgs.fetchPackwizModpack {
    url = "https://git.orangc.net/c/minecraft-modpacks/raw/commit/${cfg.packCommit}/feysac/pack.toml";
    inherit (cfg) packHash;
    # dummy: pkgs.lib.fakeHash
  };
in
{
  options.modules.services.gaming.minecraft.feysac = {
    enable = mkEnableOption "Feysac, the family vanilla+ server";

    port = mkOption {
      type = types.port;
      default = 25565;
      description = "The port the Minecraft server listens on. The default means players on the LAN only need the host's address. rcon listens on `port + 10`.";
    };

    packCommit = mkOption {
      type = types.str;
      description = "The minecraft-modpacks commit whose `feysac/pack.toml` the server runs.";
    };

    packHash = mkOption {
      type = types.str;
      description = "The hash of the packwiz modpack at `packCommit`. Set it to `lib.fakeHash` and rebuild to get the real one.";
    };

    minRAM = mkOption {
      type = types.int;
      default = 2;
      description = "The amount of RAM the server starts with (`-Xms`), in gigabytes.";
    };

    maxRAM = mkOption {
      type = types.int;
      default = 8;
      description = "The most RAM the server may use (`-Xmx`), in gigabytes.";
    };

    maxCPU = mkOption {
      type = types.int;
      default = 4;
      description = "How many CPU threads' worth of time the server may use, enforced with systemd's `CPUQuota`. It keeps world generation from cooking the host.";
    };

    motd = mkOption {
      type = types.str;
      default = "Powered by NixOS!";
      example = "Lord of Mysteries";
      description = "The message of the day, shown under the server's name in the client's server list.";
    };
  };

  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./automatic-backups.nix
  ];

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.modules.services.gaming.minecraft.enable;
        message = "feysac needs modules.services.gaming.minecraft.enable, which accepts the EULA and provides the rcon password.";
      }
    ];
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    systemd.services.minecraft-server-feysac.serviceConfig = {
      CPUQuota = "${toString (cfg.maxCPU * 100)}%";
      Nice = 5;
    };

    services.minecraft-servers.servers.feysac = {
      enable = true;
      enableReload = true;
      autoStart = true;
      restart = "always";
      jvmOpts = "-Xms${toString cfg.minRAM}G -Xmx${toString cfg.maxRAM}G";
      # nix-minecraft still wraps 26.x in java 21, which 26.x refuses
      package = pkgs.fabricServers.fabric-26_3.override {
        loaderVersion = "0.20.1";
        jre_headless = pkgs.jdk25_headless;
      };

      symlinks = {
        "mods" = "${packwiz}/mods";
        # simple resource loader reads datapacks from here, same path as in the pack
        "resources/datapack/required" = "${packwiz}/resources/datapack/required";
      };

      # carpet reads its rules from the world folder, not config/
      files."world/carpet.conf" = pkgs.writeText "carpet.conf" ''
        xpNoCooldown true
        renewableSponges true
        renewableCoral true
        renewableDeepslate true
        renewableBlackstone true
        persistentParrots true
        lightningKillsDropsFix true
        desertShrubs true
      '';

      extraStartPre = ''
        mkdir -p config
        if [ -d ${packwiz}/config ]; then
          cp -r --no-preserve=mode,ownership ${packwiz}/config/* config
        fi
        # distant horizons' lod generation otherwise pins every core it gets
        if [ -f config/DistantHorizons.toml ]; then
          ${pkgs.gnused}/bin/sed -i -E \
            -e 's/^(\s*numberOfThreads = ).*/\12/' \
            -e 's/^(\s*threadRunTimeRatio = ).*/\1"0.5"/' \
            config/DistantHorizons.toml
        fi
      '';

      operators.orangci.uuid = "dde112e5-25c7-4963-800c-aa23c3816dbc";
      whitelist = {
        orangci = "dde112e5-25c7-4963-800c-aa23c3816dbc";
        Mrlion87 = "50772de2-2341-4dc7-9ef8-708742f6ffc1";
        mythicalpengu = "9c054573-866c-4b09-89ab-f40c936a9ebd";
      };

      serverProperties = {
        motd = "§a§lFeysac§r\\n§b§o${cfg.motd}";
        server-name = "Feysac";
        level-seed = "Feysac Empire";
        server-port = cfg.port;
        difficulty = "normal";
        gamemode = "survival";
        max-players = 8;
        online-mode = true;
        white-list = true;
        enforce-whitelist = true;
        enforce-secure-profile = false;
        spawn-protection = 0;
        pause-when-empty-seconds = 300;
        # kept modest for the laptops; bobby and distant horizons cover the horizon
        view-distance = 10;
        simulation-distance = 6;
        enable-rcon = true;
        "rcon.password" = "@rcpwd@";
        "rcon.port" = cfg.port + 10;
        broadcast-rcon-to-ops = false;
        log-ips = false;
      };
    };
  };
}
