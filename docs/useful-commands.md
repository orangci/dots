# Useful Nix(OS) Commands
Some utility commands that I've found useful in my time using Nix(OS).

1. Building a VM from a configuration

`nix run .#nixosConfigurations.HOSTNAME.config.system.build.vm`

2. Cleaning up unused imports in Nix code

Prerequisites:
- Have `pkgs.deadnix` installed 
- Commit all changes before running the command in case of accidents

`deadnix -eq **/*.nix`