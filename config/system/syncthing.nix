{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) syncthing username userHome; in
lib.mkIf (syncthing == true) {
    services = {
        syncthing = {
        enable = true;
        user = "${username}";
        dataDir = "/home/${username}";    # Default folder for new synced folders
        configDir = "/home/${username}/.config/syncthing";   # Folder for Syncthing's settings and keys
        };
    };
}
