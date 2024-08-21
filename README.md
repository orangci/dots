# orangc's flake
A smol n' cozy NixOS with Hyprland flake.

## Screenshots
<details> 
<summary>Rofi</summary>

![Bindings](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/bindings.png)
![Application launcher](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/application-launcher.png)
![Wallpaper selector](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/wallpaper-selector.png)
</details>
<details>
<summary>Hyprlock</summary>

![Lockscreen 1](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/lockscreen-1.png)
![Lockscreen 2](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/lockscreen-2.png)
</details>
<details> 
<summary>Minecraft launcher</summary>

![Minecraft launcher](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/minecraft-launcher.png)
</details>
<details> 
<summary>Fetch</summary>

![Fetch](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/fetch.png)
</details>
<details> 
<summary>Discord</summary>

![Fetch](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/discord.png)
</details>
<details> 
<summary>nvim</summary>

![nvim](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/nvim.png)
</details>
<details> 
<summary>ags & thunar</summary>

![ags & thunar](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/ags-thunar.png)
</details>
<details> 
<summary>swaync</summary>

![swaync](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/swaync.png)
</details>
<details> 
<summary>wlogout</summary>

![wlogout](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/wlogout.png)
</details>
<details> 
<summary>firefox & nighttab</summary>

![firefox](https://raw.githubusercontent.com/orxngc/dots/anacreon/.github/firefox.png)
</details>

## Overview
First up, a list of most of the packages starts over [here](https://github.com/orxngc/dots/blob/main/hosts/anacreon/config.nix#L192). I'll give a quick rundown on the important stuff in case you don't want to go through that; I use Hyprland, Firefox, nvim, Hyprlock, ags, rofi, SDDM, and swaync. The file structure is simple... the configuration is in `hosts/hostname/config.nix`, the home-manager stuff in `hosts/hostname/home.nix`, scripts in `/scripts`, certain program configurations (e.g. hyprlock) in `/config`, and `/modules` for different modules. `hosts/hostname/variables.nix` is also something one may want to fool 'round with. All my wallpapers are available [here](https://github.com/orxngc/walls) and [here](https://github.com/orxngc/walls-catppuccin-mocha).

## Installation
THIS SCRIPT IS BROKEN. WILL FIX SOON.
Run this command in your terminal and the script will handle the rest. Note that this won't work for non NixOS users.

```sh
nix-shell -p curl # You can skip to the next line if you already have curl installed.
sh <(curl -L https://raw.githubusercontent.com/orxngc/dots/main/install.sh)
```
Note: I strongly advise you to read the code of the script [here](github.com/orxngc/dots/blob/main/install.sh) before running it. Always read and thoroughly check scripts you see online for your own safety..! 

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
- [x] ~~Update README screenshots.~~
- [x] ~~Make a screen recording script with wf-recorder.~~
- [x] ~~Cleanup/optimize the flake — try to make it take up less disk space.~~
</details>

- [ ] Implement proper Android virtualization. I want to play Fate/Grand Order on the PC..!
- [ ] Use the hyprpanel flake instead of whatever weird thing I'm doing right now.
- [ ] Fix the power button and lid switch activations.

## Last but not least, credits!
<details>
<summary>Thank you!</summary>

- https://gitlab.com/Zaney/zaneyos — this flake a few hundred commits ago was a fork of zaneyos; much of his code / file structure still remains here. 
- https://github.com/Jas-SinghFSU/HyprPanel — The ags configuration that I use.
- https://github.com/MrVivekRajan/Hypr-Dots — The hyprlock config inspiration.
- https://github.com/elythh/nixvim — The neovim configuration I use.
</details>
