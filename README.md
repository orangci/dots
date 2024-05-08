# orangc's dots
This is a NixOS flake. Thus you can only use this on NixOS.
It is originally built off of Zaney's [flake](https://gitlab.com/zaney/zaneyos).

What I use:
- **OS** • [`NixOS`](https://nixos.org/)
- **WM** • [`Hyprland`](https://hyprland.org)
- **Theme** • [`Catppuccin Mocha`](https://catppuccin.com/)
- **Terminal** • [`Kitty`](https://github.com/kovidgoyal/kitty)
- **Editor** • [`Neovim`](https://neovim.io/) with [`nixvim`](https://github.com/nix-community/nixvim)
- **Browser** • [`Firefox`](https://www.mozilla.org/en-US/firefox/)
- **Lockscreen** • [`Hyprlock`](https://github.com/hyprwm/hyprlock)
- **DM** • [`SDDM`](https://github.com/sddm/sddm)
- **Wallpaper Daemon** • [`swww`](https://github.com/LGFae/swww)
- **File Manager** • `Thunar`
- **Screenshots** • `grim` and `slurp`
- **Clipboard** • `cliphist` with `wl-clipboard`
- **Discord Client** • [`Vesktop`](https://vencord.dev)
- **Prompt** • [`Starship`](https://starship.rs/)
- **Image Viwer** • [`qimgv`](https://github.com/easymodo/qimgv)
- **Notification Daemon** • [`swaync`](https://github.com/ErikReider/SwayNotificationCenter)
ALl my wallpapers are available [here](https://github.com/orxngc/dots).

## Screenshots:

## Installation
Because this is a flake, it's quite easy to install. Make sure to start in your $HOME.
First clone this repository. \n
`git clone https://github.com/orxngc/dots` 
Enter it. \n
`cd dots`
Make sure to generate your hardware config. \n
`nixos-generate-config --show-hardware-config > hosts/anacreon/hardware.nix`
Enable flakes:\n
`NIX_CONFIG="experimental-features = nix-command flakes"`
Finally, running this command will install my system.\n
`sudo nixos-rebuild switch --flake .#anacreon`\n
Feel free to take these dots and modify them however you want.
