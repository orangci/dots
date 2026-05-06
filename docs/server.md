# Server Modules

[Server modules](../search?q=modules.server) are modules meant to run on a server/homelab, such as Forgejo or Immich.


## Working With mkServerModule
Here's a minimal example of a server module with mkServerModule:

```nix
# modules/server/example.nix
{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.server.example;
in
{
  options.modules.server.example = lib.my.mkServerModule { name = "Example"; };
  config = mkIf cfg.enable {
    services.example = {
        enable = true;
        inherit (cfg) port;
    };
  };
}
```

Enabling it:

```nix
# hosts/hostname/config.nix
{
    modules.server.example = {
        enable = true;
        glance.enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        ntfyChecking.enable = true;
        port = 8804;
        # a few more options are available for mkServerModule modules which you can see at lib/options/mkServerModule.nix
    };
}
```

## Working Without mkServerModule
Note that automatic cloudflared/glance/caddy/ntfy integration for mkServerModule modules only works for modules.server.x modules, and not modules.server.x.y modules.

If you want to integrate these into your modules manually:
```nix
# example.nix
{ lib, ... }: {
    modules.server = {
        caddy.virtualHosts = lib.my.mkCaddyEntry "subdomain-name" 8804 true;
        # 8804 is the port to serve on, and true/false is for enabling or disabling internal tailnet domains at subdomain-name.${flakeSettings.domains.tailnet}
        cloudflared.ingress = lib.my.mkCloudflaredIngress "subdomain-name" 8804;
        glance.monitoredSites = lib.singleton {
            url = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
            title = cfg.name;
            icon = "sh:example";
            # si for Simple icons https://simpleicons.org/
            # sh for selfh.st icons https://selfh.st/icons/
            # di for Dashboard icons https://github.com/homarr-labs/dashboard-icons
            # mdi for Material Design icons https://pictogrammers.com/library/mdi/
            # prefix with auto-invert for inverting colours based on browser colourscheme
            # e.g. auto-invert sh:example
        };
    };
}
```

## Individual Server Modules
Guides to invidual server modules where necessary. Please assume that any YAML snippets belong in `secrets/secrets.yaml` unless stated otherwise.

### Forgejo
```yaml
forgejo-runner-registration-token: your-registration-token
```
This secret is for allowing the Forgejo runner for Forgejo actions to authenticate with your Forgejo instance. If it is the first time you are running Forgejo, make a placeholder secret for now. Find your token by navigating to Site Administration > Actions > Show Registration Token.

If you have Renovate enabled, you'll need two secrets:
```yaml
renovate:
    forgejo-token: your-forgejo-token
    github-token: your-github-token
```
To obtain a Forgejo token for your Renovate bot, first create a user account for it on your Forgejo instance. Once this is done, login to the renovate bot's account and go to Settings > Applications > New access token. Name the token `renovate`, and give it access to all resources. For the permissions, you will need `Read and Write` for `repo`, `issue`, and `organization`. `user` will just need `Read` permissions. You may now generate and use your token.

To obtain a GitHub token, simply visit [this page](https://github.com/settings/tokens) and click "Generate new token". You may use either type; there is no need to give the token any permissions, as it is needed for read-only operations alone.

### Matrix
Keep in mind that once you set `modules.server.matrix.serverName`, you *cannot* change it unless you wipe the database.
To make a new Matrix user, simply run `matrix-synapse-register_new_matrix_user` without any arguments.
```yaml
matrix-synapse-registration-shared: any randomly generated string, try openssl rand -hex 32
```

In order for federation to work, you also must serve `your-matrix-api-domain.net/.well-known/matrix`.
Here is an example Cloudflare worker:
```js
const HOMESERVER_URL = "https://matrix.orangc.net";
const IDENTITY_SERVER_URL = "https://orangc.net";
const FEDERATION_SERVER = "matrix.orangc.net:443";

export default {
  async fetch(request, env) {
    const path = new URL(request.url).pathname;
    switch (path) {
      case "/.well-known/matrix/client":
        return new Response(
            `{"m.homeserver": {"base_url": "${HOMESERVER_URL}"},"m.identity_server": {"base_url": "${IDENTITY_SERVER_URL}"}}`
        );
      case "/.well-known/matrix/server":
        return new Response(`{"m.server": "${FEDERATION_SERVER}"}`);
      default:
        return new Response("Invalid request");
      }
    },
};
```

Where matrix.orangc.net is `${cfg.subdomain}.${flakeSettings.domains.primary}` and orangc.net is `cfg.serverName`.