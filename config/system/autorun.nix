{ pkgs, config, username, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) wallpaperDir wallpaperGit; in
{
  # system.userActivationScripts = {
  #   gitwallpapers.text = ''
  #   '';
  # };
}
