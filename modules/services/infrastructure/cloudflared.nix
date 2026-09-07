{
  config,
  lib,
  flakeSettings,
  ...
}:

let
  inherit (lib) types;
  cfg = config.modules.services.infrastructure.cloudflared;

  validModules = lib.concatMapAttrs (
    _: v:
    lib.filterAttrs (
      _: mod: mod.autoConfiguredServiceInfra or false && mod.cloudflared.enable or false
    ) v
  ) config.modules.services;

  mkIngress =
    domain:
    lib.mapAttrs' (
      _: mod: lib.nameValuePair "${mod.subdomain}.${domain}" "http://localhost:${toString mod.port}"
    ) validModules;

  domains = lib.filter (d: d != "" && d != null) [
    flakeSettings.domains.primary
    flakeSettings.domains.secondary
  ];

in
{
  options.modules.services.infrastructure.cloudflared = {
    enable = lib.mkEnableOption "Enable Cloudflared";
    ingress = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Collect ingress entries from other modules";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.security.sops.secrets."cloudflared/cert.pem".path = "/var/secrets/cloudflared/cert.pem";
    modules.security.sops.secrets."cloudflared/credentials.json".path =
      "/var/secrets/cloudflared/credentials.json";

    services.cloudflared = {
      enable = true;
      tunnels.homelab = {
        default = "http_status:404";
        certificateFile = config.modules.security.sops.secrets."cloudflared/cert.pem".path;
        credentialsFile = config.modules.security.sops.secrets."cloudflared/credentials.json".path;
        ingress = lib.mkMerge ((map mkIngress domains) ++ lib.singleton cfg.ingress);
      };
    };
    # important note:
    # this systemd service is from
    # https://git.satr14.my.id/satr14/nix-flake/src/commit/8745a66a2a00828c358a3899f9247751dd8a0c4b/modules/system/homelab/tunnels.nix
    # it is licensed under the MIT license by satr14
    # https://git.satr14.my.id/satr14/nix-flake/src/commit/8745a66a2a00828c358a3899f9247751dd8a0c4b/LICENSE
    systemd.services.cloudflared-dns-route = {
      description = "Sync Cloudflare Tunnel DNS routes";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        RemainAfterExit = true;
        Type = "oneshot";
        User = "root";
      };

      script = lib.concatMapStringsSep "\n" (domain: ''
        echo "Ensuring DNS route for ${domain}..."
        ${pkgs.cloudflared}/bin/cloudflared tunnel --origincert /mnt/data/apps/cloudflared/cert.pem route dns --overwrite-dns $(cat /mnt/data/apps/cloudflared/homelab.json | ${pkgs.jq}/bin/jq -r .TunnelID) ${domain} || true
      '') (builtins.attrNames config.services.cloudflared.tunnels.homelab.ingress);
    };
  };
}
