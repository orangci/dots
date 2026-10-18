{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.security.sudo-rs;
in
{
  imports = lib.singleton (
    lib.mkAliasOptionModule [ "modules" "security" "sudo-rs" ] [ "security" "sudo-rs" ]
  );

  config = mkIf cfg.enable {
    # lets the frnix claude skill rebuild without a password prompt
    security.sudo-rs.extraRules = lib.singleton {
      groups = [ "wheel" ];
      commands = lib.singleton {
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      };
    };
  };
}
