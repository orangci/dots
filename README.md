# orangc's flake
A smol (big lie, it's not that smol.. see the todo section) n' cozy NixOS with Hyprland flake.

## Screenshots
<details> 
![Bindings](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/bindings.png)
<summary>Rofi</summary>

![Application launcher](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/application-launcher.png)
![Wallpaper selector](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/wallpaper-selector.png)
![Minecraft launcher](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/minecraft-launcher.png)
</details>
<summary>Hyprlock</summary>

![Lockscreen 2](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/lockscreen-2.png)
</details>
<summary>Hyprlock</summary>

![Minecraft launcher](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/minecraft-launcher.png)
</details>
<summary>Fetch</summary>

![Fetch](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/fetch.png)
</details>
<summary>nvim</summary>

![nvim](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/nvim.png)
</details>
<summary>ags & thunar</summary>

![ags & thunar](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/ags-thunar.png)
</details>
<summary>swaync</summary>

![swaync](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/swaync.png)
</details>
<summary>wlogout</summary>

![wlogout](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/wlogout.png)
</details>
<summary>clipboard</summary>

![clipse](https://raw.githubusercontent.com/orxngc/dots/anacreon/assets/clipse.png)
</details>

## Overview
First up, a list of most of the packages starts over [here](https://github.com/orxngc/dots/blob/main/hosts/anacreon/config.nix#L192). I'll give a quick rundown on the important stuff in case you don't want to go through that; I use Hyprland, Firefox, nvim, Hyprlock, ags, rofi, SDDM, and swaync. The file structure is simple... the configuration is in hosts/hostname/config.nix, the home-manager stuff in hosts/hostname/home.nix, scripts in /scripts, certain program configurations (e.g. hyprlock) in /config, and /modules for different modules. hosts/hostname/variables.nix is also something one may want to fool 'round with. All my wallpapers are available [here](https://github.com/orxngc/walls) and [here](https://github.com/orxngc/walls-catppuccin-mocha).

## Installation
Run this command in your terminal and the script will handle the rest. Note that this won't work for non NixOS users.

```sh
nix-shell -p curl # You can skip to the next line if you already have curl installed.
sh <(curl -L https://raw.githubusercontent.com/orxngc/dots/main/install.sh) # Worried that I'm putting a virus in your PC? Read the code here to be sure: github.com/orxngc/dots/blob/main/install.sh
```

Press `SUPER + ?` to open a list of all keybindings.
 
## Todo
<details> 
<summary>Completed</summary>
- [x] ~~Write an installation script.~~
- [x] ~~Create a rofi wallpaper selector thing.~~
- [x] ~~Make swaync notifications pretty.~~
- [x] ~~Make those annoying folders in $HOME disappear, they aren't welcome.~~
- [x] ~~Add something that lists all the keybindings.~~
- [x] ~~Move back to SDDM or some other DM because I want something pretty.~~
- [x] ~~Update README screenshots / add a video showcase.~~
</details>
- [ ] Cleanup/optimize the flake — try to make it take up less disk space.
- [ ] Implement proper Android virtualization. I want to play Fate/Grand Order on the PC..!

<details>
<summary>Last but not least, credits!</summary>
*An important note: many of the configurations in my dots are modified from __many__ other opensource dotfile repositories. Without those, this wouldn't be possible!*
- https://gitlab.com/Zaney/zaneyos
- https://github.com/Jas-SinghFSU/HyprPanel
- https://github.com/MrVivekRajan/Hypr-Dots
- https://github.com/prasanthrangan/hyprdots
- https://github.com/elythh/nixvim
</details>
