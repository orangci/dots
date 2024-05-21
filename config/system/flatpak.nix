{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) flatpak; in
lib.mkIf (flatpak == true) {
  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
