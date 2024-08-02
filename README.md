# orangc's flake

An important note: many of the configurations here are modified from *many* other opensource dotfile repositories. Without those, this wouldn't be possible!

Another, less important note; if you want to use my dotfiles, note that the nice waybar settings you see in the screenshots aren't something you'll see immediately; I have waybar disabled at startup. You change this by `waybarEnable = true;` in /hosts/anacreon/variables.nix, and removing the exec-once for ags in /config/hyprland.nix. This is because I actually use ags, with [this](https://github.com/Jas-SinghFSU/HyprPanel) amazing configuration.

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

All my wallpapers are available [here](https://github.com/orxngc/walls).

<details>
  <summary>Screenshots:</summary>
Note — these screenshots are outdated.

![Tiled](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/tiledGalaxy.png)

![Blank](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/blank.png)

![Sakura](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/floating.png)

![Boxy](https://raw.githubusercontent.com/orxngc/dots/anacreon/config/desktopPics/boxyStyle.png)

</details>

## Installation
No need to clone the repository, the install script will do that for you. Just download install.sh and it'll handle the rest.

Press `SUPER + ?` to open a list of all keybindings.
 
## Todo
- [x] Write an installation script
- [x] Create a rofi wallpaper selector thing.
- [x] Make swaync notifications pretty.
- [x] Make those annoying folders in $HOME disappear, they aren't welcome.
- [x] Add something that lists all the keybindings.
- [ ] Move back to SDDM or some other DM because I want something pretty.
- [ ] Update README screenshots
- [ ] Implement proper Android virtualization. 