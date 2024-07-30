# orangc's flake

An important note: many of the configurations here are taken from *many* other opensource dotfile repositories I will be modifying them even more later). Without those, this wouldn't be possible!

Another, less important note; if you want to use my dotfiles, note that the nice waybar settings you see in the screenshots aren't something you'll see immediately; I have waybar disabled at startup. You change this by `waybarEnable = true;` in /hosts/anacreon/variables.nix. This is because I actually use ags, with [this](https://github.com/Jas-SinghFSU/HyprPanel) amazing configuration.

What I use:

- **OS** • [`NixOS`](https://nixos.org/)
- **WM** • [`Hyprland`](https://hyprland.org)
- **Theme** • [`Catppuccin Mocha`](https://catppuccin.com/)
- **Terminal** • [`Kitty`](https://github.com/kovidgoyal/kitty)
- **Editor** • [`Neovim`](https://neovim.io/)
- **Browser** • [`Firefox`](https://www.mozilla.org/en-US/firefox/)
- **Lockscreen** • [`Hyprlock`](https://github.com/hyprwm/hyprlock)
- **DM** • [`tuigreet`](https://github.com/apognu/tuigreet)
- **Wallpaper Daemon** • [`swww`](https://github.com/LGFae/swww)
- **File Manager** • `Thunar`
- **Screenshots** • [`grimblast`](https://github.com/hyprwm/contrib)
- **Clipboard** • [`clipse`](https://github.com/savedra1/clipse)
- **Prompt** • [`Starship`](https://starship.rs/)
- **Image Viwer** • [`qimgv`](https://github.com/easymodo/qimgv)
- **Fetch** • [`nitch`](https://github.com/ssleert/nitch) & [`fastfetch`](https://github.com/fastfetch-cli/fastfetch)

All my wallpapers are available [here](https://github.com/orxngc/walls-catppuccin-mocha).

<details>
  <summary>Screenshots:</summary>
Note — these screenshots are outdated.

![Tiled](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/tiledGalaxy.png)

![Blank](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/blank.png)

![Sakura](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/floating.png)

![Boxy](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/boxyStyle.png)

</details>

## Installation

Because this is a flake, it's quite easy to install. Make sure to start in your $HOME.
First clone this repository.

`git clone https://github.com/orxngc/dots`

Enter it.

`cd dots`

Make sure to generate your hardware config.

`nixos-generate-config --show-hardware-config > hosts/anacreon/hardware.nix`

Enable flakes:

`NIX_CONFIG="experimental-features = nix-command flakes"`

Finally, running this command will install my system.

`sudo nixos-rebuild switch --flake .#anacreon`

Feel free to take these dots and modify them however you want.

## Todo
- [ ] Write an installation script
- [ ] Update README screenshots
- [ ] Switch what I can from rofi to walker/other programs & utilities
- [ ] Implement proper Android virtualization. 
- [ ] Create a rofi wallpaper selector thing.
- [ ] Move back to SDDM or some other DM because I want something pretty.
- [ ] Make swaync notifications pretty.