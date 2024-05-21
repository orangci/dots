{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Enable &/ Configure Programs
    ./alacritty.nix
    ./bash.nix
    ./gtk-qt.nix
    ./hyprland.nix
    ./kdenlive.nix
    ./kitty.nix
    ./neovim.nix
    ./packages.nix
    ./rofi.nix
    ./starship.nix
    ./waybar.nix
    ./wlogout.nix
    ./swappy.nix
    ./swaync.nix
    ./wezterm.nix
    ./zeroad.nix
    ./zsh.nix
    ./hyprlock.nix
    ./fastfetch.nix

    # Place Home Files Like Pictures
    ./files.nix
  ];
}
