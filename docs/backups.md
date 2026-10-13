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

The repository defaults to `/mnt/backup`, which is a separate HDD. **Mount it before enabling the module**, otherwise restic will happily initialise a repository on the root drive and fill it up.

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

## Restic server
If grafana is enabled on the host, the module also runs a restic REST server on `127.0.0.1:9636` with Prometheus metrics turned on. It's for graphing, not for the backups themselves.

## Other backups
- The Minecraft server has its own backup script, see [`automatic-backups.nix`](../modules/services/gaming/minecraft/servers/juniper/utilities/automatic-backups.nix). It tars the world daily into the `minecraft` user's `~/backups` and keeps about three days' worth. Those tarballs are **not** in the restic `paths`, so they only protect against a corrupted world, not a dead drive.
- Postgres is covered only by backing up `/var/lib/postgresql` as files. That's fine while the databases are idle and less fine otherwise. A proper `pg_dump` would be better.
