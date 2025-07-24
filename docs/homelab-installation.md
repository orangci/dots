# Installation
https://nixos.org/manual/nixos/stable/#sec-installation-manual

- [x] Plug the computer in (after finding a suitable place to do so). Boot it to check if it works.
- [x] Install NixOS onto the computer (assuming the main drive is `/dev/sda`):
    - `wipefs -a /dev/sda`
    - `nix-shell -p parted git btrfs-progs`
    - `parted /dev/sda -- mklabel gpt`
    - `parted /dev/sda -- mkpart root btrfs 512MB`
    - `parted /dev/sda -- mkpart ESP fat32 1MB 512MB`
    - `parted /dev/sda -- set 2 esp on`
    - `mkfs.btrfs -L gensokyo /dev/sda1`
    - `mkfs.fat -F 32 -n boot /dev/sda2`
    - `mount /dev/disk/by-label/gensokyo /mnt`
    - `mkdir -p /mnt/boot`
    - `mount -o umask=077 /dev/disk/by-label/boot /mnt/boot`
    - `nixos-generate-config --root /mnt --show-hardware-config > dots/hosts/gensokyo/hardware.nix`
    - Commit and push
    - `nixos-install --flake .#gensokyo`
    - `nixos-enter --root /mnt`
    - `passwd orangc`
    - `cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age`
    - Setup secrets configuration with the above host key.
    - Use `ip a` to find the local IP. From now on, we will assume it is `192.168.1.42`.
    - `reboot`
- [ ] Reserve `192.168.1.42` in my router’s DHCP settings using gensokyo's MAC address.
- [ ] To get the MAC address, run `ip link` or `ip link show | grep -A1 'state UP' | grep ether`.
- [ ] In Technitium settings, set DNS overrides for all *.orangc.net subdomains in usage, so that we can use LAN.
- [x] Create an account on the Gitea instance, then disable registration. Set up mirroring with GitHub repositories.
- [x] Create an account on the immich instance, then disable registration. Move wallpapers to Immich albums, make them public, and archive wallpaper related GitHub repositories.
- [x] Create an account on the vaultwarden instance, then disable registration. Create a Proton Pass backup and import it into Vaultwarden.
- [x] Set up Jellyfin.
- [x] Regenerate the following secrets and place them in secrets.yaml: technitium, speedtest, immich, ntfy.
- [x] Check the other services in order to confirm that they're all working.
- [x] Pregenerate Juniper's chunks, put it in maintenance mode, and set the world border to 1,000. Set up rconc with `sudo -u minecraft rconc server add jp localhost:7810 password`.

Use `ssh orangc@192.168.1.42` in order to SSH into the homelab.
