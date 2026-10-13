# Server Modules

Server modules are the ones under `modules.services.*` ([`modules/services`](../modules/services)). They're meant to run on a server/homelab, such as Forgejo or Immich, and are sorted into categories like `media`, `files` and `monitoring`.


## Working With mkServerModule
Here's a minimal example of a server module with mkServerModule:

```nix
# modules/services/category/example.nix
{ config, lib, ... }:
let
  inherit (lib) mkIf;
  cfg = config.modules.services.category.example;
in
{
  options.modules.services.category.example = lib.my.mkServerModule { name = "Example"; };
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
    modules.services.category.example = {
        enable = true;
        glance.enable = true;
        cloudflared.enable = true;
        internalTailscaleDomain.enable = true;
        ntfyChecking.enable = true;
        port = 8804;
        # a few more options are available for mkServerModule modules which you can see at lib/mkServerModule.nix
    };
}
```

## What mkServerModule gives you
- `enable`, `port`, `subdomain` (defaults to the lowercased name), and `name` (for display purposes).
- `cloudflared.enable` ~ exposes the service publicly through the Cloudflare Tunnel on `subdomain.<primary and secondary domain>`.
- `internalTailscaleDomain.enable` ~ serves it on `subdomain.<tailnet domain>`, reachable from the tailnet only.
- `glance.enable` (and `glance.icon`) ~ shows it on the Glance dashboard.
- `ntfyChecking.enable` ~ gets a notification on [ntfy](./ntfy.md) if the service stops responding.
- `autoConfiguredServiceInfra` ~ set it to `false` in the `mkServerModule` call if Caddy and friends shouldn't touch the service at all.

Caddy, Cloudflared, Glance and the ntfy checker each go through every `modules.services.category.name` module and read these options, so the module itself never has to mention them. Ports are in the 88xx range; check [gensokyo's config](../hosts/gensokyo/config.nix) for what's taken before picking one.

## Working Without mkServerModule
Note that automatic cloudflared/glance/caddy/ntfy integration for mkServerModule modules only works for `modules.services.category.name` modules, and not anything nested deeper (e.g. `modules.services.media.nixflix.radarr`).

If you want to integrate these into your modules manually:
```nix
# example.nix
{ lib, ... }: {
    modules.services = {
        infrastructure.caddy.virtualHosts = lib.my.mkCaddyEntry "subdomain-name" 8804 true;
        # 8804 is the port to serve on, and true/false is for enabling or disabling internal tailnet domains at subdomain-name.${flakeSettings.domains.tailnet}
        infrastructure.cloudflared.ingress = lib.my.mkCloudflaredIngress "subdomain-name" 8804;
        monitoring.glance.monitoredSites = lib.singleton {
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
Keep in mind that once you set `modules.services.misc.matrix-synapse.serverName`, you *cannot* change it unless you wipe the database.
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