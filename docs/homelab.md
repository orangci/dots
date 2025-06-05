# Urithiru Plan

# Checklist
- [ ] Chibisafe module
- [ ] Test if the cloudflared/caddy modules work (i.e. if the services are actually accessible)
- [ ] [2FAuth](https://docs.2fauth.app/) module
- [ ] [opnform](https://opnform.com/) module
- [ ] discord bot / discord bot's mongodb✓ (database) instance modules
- [ ] matrix homeserver module
- [ ] [mastodon](https://github.com/mastodon/mastodon) module
- [ ] [olivetin](https://www.olivetin.app) module
- [ ] [bracket](https://docs.bracketapp.nl/) module
- [ ] website and [umami](https://umami.is) module
- [ ] [ollama](https://ollama.com/) module

Things to consider hosting:
- [discount bandit](https://discount-bandit.cybrarist.com/) module
- [convos](https://convos.chat) module
- [commafeed](https://github.com/Athou/commafeed) module

## Setup checklist
- [ ] Plug the computer in (after finding a suitable place to do so). Boot it to check if it works.
- [ ] Install NixOS onto the computer (assuming the main drive is `/dev/sda`):
    - `wipefs -a /dev/sda`
    - `nix-shell -p parted git`
    - `parted /dev/sda -- mklabel gpt`
    - `parted /dev/sda -- mkpart primary fat32 1MiB 513MiB`
    - `parted /dev/sda -- set 1 esp on`
    - `parted /dev/sda -- mkpart primary ext4 513MiB 100%`
    - `mkfs.vfat -F32 /dev/sda1`
    - `mkfs.ext4 /dev/sda2`
    - `mount /dev/sda2 /mnt`
    - `mkdir /mnt/boot`
    - `mount /dev/sda1 /mnt/boot`
    - `git clone https://github.com/orangci/dots && cd dots`
    - `nixos-generate-config --root /mnt --show-hardware-config > hosts/urithiru/hardware.nix`
    - `nixos-install --flake .#urithiru --root /mnt`
    - `nixos-enter --root /mnt`
    - `git clone https://github.com/orangci/dots && cd dots`
    - `nixos-generate-config --show-hardware-config > hosts/urithiru/hardware.nix && nixos-rebuild --flake .#urithiru`
    - `sudo passwd orangc <new password>`
    - `sudo passwd same password as above`
    - `cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age`
    - Setup secrets configuration with the above host key.
    - Use `ip a` to find the local IP. From now on, we will assume it is `192.168.1.42`.
    - `reboot`
- [ ] Reserve `192.168.1.42` in my router’s DHCP settings using urithiru's MAC address.
- [ ] To get the MAC address, run `ip link` or `ip link show | grep -A1 'state UP' | grep ether`.
- [ ] In Technitium settings, set DNS overrides for all *.orangc.net subdomains in usage, so that we can use LAN.
- [ ] Create an account on the Gitea instance, then disable registration. Set up mirroring with GitHub repositories.
- [ ] Create an account on the Chibisafe instance, then disable registration.
- [ ] Create an account on the calibre-web instance, then disable registration.
- [ ] Create an account on the immich instance, then disable registration. Move wallpapers to Immich albums, make them public, and archive wallpaper related GitHub repositories.
- [ ] Create an account on the vaultwarden instance, then disable registration. Create a Proton Pass backup and import it into Vaultwarden.
- [ ] Configure Glance. Do not forget the uptime-kuma plugin.
- [ ] Check the other services in order to confirm that they're all working.
<!-- - [ ] Create a backup of of Juniper and move it into `/var/lib/minecraft`. Enable `modules.server.minecraft.juniper.enable`. -->

Use `ssh orangc@192.168.1.42` in order to SSH into the homelab.