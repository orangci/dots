# Useful Nix(OS) Commands
Some utility commands that I've found useful in my time using Nix(OS).

1. Building a VM from a configuration

`nix run .#nixosConfigurations.HOSTNAME.config.system.build.vm`

2. Cleaning up unused imports in Nix code

Prerequisites:
- Have `pkgs.deadnix` installed 
- Commit all changes before running the command in case of accidents

`deadnix -eq **/*.nix`

3. What depends on a package?

`nix why-depends /run/current-system nixpkgs#package-name'

4. Only update a specific flake input

`nix flake update --update-input <input-name>`

5. Cleaning up unused containers (usually used after disabling a server module that utilises oci-containers)

`sudo podman system prune --all --volumes`

6. To quickly open a port in the firewall:

`sudo iptables -I INPUT -p tcp --dport 1234 -j ACCEPT`

And to close it again:

`sudo iptables -D INPUT -p tcp --dport 1234 -j ACCEPT`.