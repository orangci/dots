# Installation
https://nixos.org/manual/nixos/stable/#sec-installation-manual

This assumes that you are running these commands from a NixOS system yourself. If you do not have the dots directory, get it via `git clone https://github.com/orangci/dots`. Replace HOSTNAME and USERNAME with your intended hostname and username respectively. For documentation on installing for homelab/server usage, see the [relevant documentation](./homelab-installation.md).

This installation does not create a swap partition. Edit/add commands as you see fit in order to create one, if necessary.

- `wipefs -a /dev/sda`
- `nix-shell -p parted git btrfs-progs`
- `parted /dev/sda -- mklabel gpt`
- `parted /dev/sda -- mkpart root btrfs 512MB`
- `parted /dev/sda -- mkpart ESP fat32 1MB 512MB`
- `parted /dev/sda -- set 2 esp on`
- `mkfs.btrfs -L HOSTNAME /dev/sda1`
- `mkfs.fat -F 32 -n boot /dev/sda2`
- `mount /dev/disk/by-label/HOSTNAME /mnt`
- `mkdir -p /mnt/boot`
- `mount -o umask=077 /dev/disk/by-label/boot /mnt/boot`
- `nixos-generate-config --root /mnt --show-hardware-config > dots/hosts/HOSTNAME/hardware.nix`
- Commit and push (or, if you're not me, `git add .`)
- `nixos-install --flake .#HOSTNAME`
- `nixos-enter --root /mnt`
- `passwd USERNAME`
- `cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age`
- Setup secrets configuration with the above host key.