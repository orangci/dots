{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.technitium;
  stateDir = "/var/lib/technitium-dns-server";
in
{
  options.modules.server.technitium.enable = mkEnableOption "Enable technitium";

  config = mkIf cfg.enable {
    systemd.services.technitium-dns-server = {
      description = "Technitium DNS Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.technitium-dns-server}/bin/technitium-dns-server ${stateDir}";

        User = "technitium";
        Group = "technitium";
        DynamicUser = false;
        StateDirectory = "technitium-dns-server";
        WorkingDirectory = stateDir;
        BindPaths = stateDir;

        Restart = "always";
        RestartSec = 10;
        TimeoutStopSec = 10;
        KillSignal = "SIGINT";

        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
    users.users.technitium = {
      isSystemUser = true;
      initialPassword = "a";
      group = "technitium";
    };

    users.groups.technitium = { };
  };
}
