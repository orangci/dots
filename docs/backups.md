# Backups
Backups are done with restic, through the [`modules.security.restic`](../modules/security/restic.nix) module. At the moment only gensokyo uses it.

## How it works
One restic job, `grand-backup`, backs up every path in `modules.security.restic.paths` to a single repository. Snapshots are pruned down to the newest `keepLast` (5 by default), and the repository is checked after each run. The timer is NixOS's default for restic, i.e. daily.

```nix
# hosts/gensokyo/config.nix
modules.security.restic = {
    enable = true;
    paths = [ "/var/lib/immich" "/var/lib/forgejo" ];
    # repository = "/mnt/backup";
    # keepLast = 5;
};
```

The repository defaults to `/mnt/backup`, which is a separate HDD. It's mounted with `nofail` so a dead drive doesn't stop gensokyo booting, which is why the backup service has `RequiresMountsFor` on the repository: if the drive isn't there, the backup fails instead of quietly initialising a new repository on the root drive.

When adding a new service that keeps state, remember to add its data directory to `paths`. Nothing does this automatically.

## Secrets
The repository password is the `restic-password` secret, placed at `/var/secrets/restic-password`. See [secrets](./secrets.md). **Keep a copy of it somewhere that isn't gensokyo.** If gensokyo dies and the only copy of the password was on it, the backups are useless.

## Commands
NixOS gives us a wrapper called `restic-grand-backup` that already knows the repository and password, so run it with sudo.

List snapshots:

`sudo restic-grand-backup snapshots`

Back up right now instead of waiting for the timer:

`sudo systemctl start restic-backups-grand-backup.service`

Check on how it went:

`journalctl -u restic-backups-grand-backup.service`

Restore a single path from the latest snapshot into a scratch directory (don't restore straight over a running service):

`sudo restic-grand-backup restore latest --target /tmp/restore --include /var/lib/forgejo`

Browse a snapshot without restoring anything:

`sudo restic-grand-backup mount /tmp/mnt`

## Other backups
- The Minecraft server has its own backup script, see [`automatic-backups.nix`](../modules/services/gaming/minecraft/servers/juniper/utilities/automatic-backups.nix). It tars the world daily into the `minecraft` user's `~/backups` and keeps about three days' worth. Those tarballs are **not** in the restic `paths`, so they only protect against a corrupted world, not a dead drive.
- Postgres is mostly covered by backing up `/var/lib/postgresql` as files. That's fine while the databases are idle and less fine otherwise. Takina's database is the exception: it gets a daily `pg_dump` into `/var/backups/takina` (last seven kept), and that directory is in `paths`, so restore from those dumps rather than the raw files.
- Vaultwarden keeps its own consistent copy of its database in `/var/backup/vaultwarden`, which is also in `paths`.
