{
  config,
  lib,
  pkgs,
  myPkgs,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.misc.mudaremote;
in
{
  options.modules.services.misc.mudaremote = {
    enable = mkEnableOption "MudaRemote Mudae scripting/automation";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets."mudaremote/main-account-token".path =
      "/var/secrets/mudaremote-main-account-token";
    modules.security.sops.secrets."mudaremote/alt-account-token".path =
      "/var/secrets/mudaremote-alt-account-token";

    systemd.services.mudaremote-main = {
      description = "MudaRemote Mudae automation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        WorkingDirectory = myPkgs.mudaremote;
        ExecStart = pkgs.writeShellScript "mudaremote-run" ''
          set -eu
          exec ${myPkgs.mudaremote.python}/bin/python ${myPkgs.mudaremote}/mudae_preset_editor.py --preset "Main"
        '';
        EnvironmentFile = config.modules.security.sops.secrets."mudaremote/main-account-token".path;
        Restart = "on-failure";
        RestartSec = 10;
        StateDirectory = "mudaremote";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };

    systemd.services.mudaremote-alt = {
      description = "MudaRemote Mudae automation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        WorkingDirectory = myPkgs.mudaremote;
        ExecStart = pkgs.writeShellScript "mudaremote-run-alt" ''
          set -eu
          exec ${myPkgs.mudaremote.python}/bin/python ${myPkgs.mudaremote}/mudae_preset_editor.py --preset "Main"
        '';
        EnvironmentFile = config.modules.security.sops.secrets."mudaremote/alt-account-token".path;
        Restart = "on-failure";
        RestartSec = 10;
        StateDirectory = "mudaremote";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };
  };
}
