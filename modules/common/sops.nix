# For documentation on this module, see `/docs/secrets.md`.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkAliasOptionModule;
  cfg = config.modules.common.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    (mkAliasOptionModule ["modules" "common" "sops" "secrets"] ["sops" "secrets"])
  ];

  options.modules.common.sops.enable = mkEnableOption "Enable sops-nix secret management";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.sops pkgs.age pkgs.ssh-to-age];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      age.keyFile = "/var/lib/sops-nix/key.txt";
      age.generateKey = true;
    };
  };
}
