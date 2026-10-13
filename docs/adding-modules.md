# Adding Modules
Copy the relevant `example.nix` and go from there. They're ignored by the importer, so they never get loaded.

| What | Copy | Options live at |
| --- | --- | --- |
| A generic NixOS module | [`modules/example.nix`](../modules/example.nix) | `modules.category.name` |
| A homelab service | [`modules/services/example.nix`](../modules/services/example.nix) | `modules.services.category.name` |
| A home-manager module | [`home/example.nix`](../home/example.nix) | `hmModules.category.name` |

The category is just the directory it sits in. `modules/hardware/bluetooth.nix` becomes `modules.hardware.bluetooth`, and `modules/services/media/immich.nix` becomes `modules.services.media.immich`. Keep the option path and the file path in sync, it makes things findable.

## Steps
1. Put the file in the right directory. No imports to add, [everything gets imported automatically](./overview.md#how-modules-get-loaded).
2. Gate everything behind `mkIf cfg.enable`.
3. Enable it in `hosts/HOSTNAME/config.nix` (system modules) or `hosts/HOSTNAME/homes/USERNAME.nix` (home modules).
4. `git add` the new file. Flakes ignore files git doesn't know about, which will confuse you at least once.
5. `nixos-rebuild build --flake .#HOSTNAME` (or `nh os build`) to check that it evaluates.

If the module needs secrets, see [secrets](./secrets.md). If it's a homelab service, you almost certainly want [`mkServerModule`](./server.md).

## Small things
- Describe every option you add. They end up on the docs site.
- If a module is broken or half finished, say so in a comment at the top. Future me will thank past me.
- Never let a module reach into another module's config without checking that the other module is enabled.
