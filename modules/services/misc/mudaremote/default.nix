{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.services.misc.mudaremote;
  inherit (inputs.self.packages.${system}) mudaremote;
in
{
  options.modules.services.misc.mudaremote = {
    enable = mkEnableOption "MudaRemote Mudae scripting/automation";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.mudaremote-account-tokens.path =
      "/var/secrets/mudaremote-account-tokens";

    systemd.services.mudaremote-main = {
      description = "MudaRemote Mudae automation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        WorkingDirectory = mudaremote;
        ExecStart = pkgs.writeShellScript "mudaremote-run" ''
          set -eu
          exec ${mudaremote.python}/bin/python ${mudaremote}/mudae_preset_editor.py --preset "Main"
        '';
        EnvironmentFile = config.modules.security.sops.secrets.mudaremote-account-tokens.path;
        Restart = "on-failure";
        RestartSec = 10;
        StateDirectory = "mudaremote";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };
  };
}
