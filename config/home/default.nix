{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Enable &/ Configure Programs
    ./bash.nix
    ./gtk-qt.nix
    ./hyprland.nix
    ./kitty.nix
    ./neovim.nix
    ./packages.nix
    ./rofi.nix
    ./waybar.nix
    ./swappy.nix
    ./swaync.nix
    ./zsh.nix
    ./hyprlock.nix
    ./fastfetch.nix

    # Place Home Files Like Pictures
    ./files.nix
  ];
}
