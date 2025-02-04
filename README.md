<div align="center">
      <h1>orangc's flake</h1>
      <div align="center">
         <a href="https://github.com/orangci/dots/stargazers">
            <img src="https://img.shields.io/github/stars/orangci/dots?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6">
         </a>
         <a href="https://github.com/orangci/dots/">
            <img src="https://img.shields.io/github/repo-size/orangci/dots?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6">
         </a>
         <a = href="https://nixos.org">
            <img src="https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3">
         </a>
         <a href="https://github.com/orangci/dots/blob/main/LICENSE">
            <img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=GPL3&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&"/>
         </a>
</div> <br>

> [!CAUTION]
> This flake is extremely unstable and prone to breaking changes..
> I do ***not*** recommmend using this/installing it, it will definitely break.
> However, going through my code for little bits and things to borrow or learn from is totally fine.
> A process of rewriting my entire configuration starts
> after commit [`09709dc7f716bf1df7c836dfc191e88ec1ad8339`](https://github.com/orangci/dots/commit/09709dc7f716bf1df7c836dfc191e88ec1ad8339).

## todo
- secure boot
- reorganize
- cut down disk usage
- urithiru (homelab) setup
- impermanence
- make scripts use pkgs.writeShellApplication
- use nil / nix language server
- (maybe) use nvf
- fix fonts

<!-- <details> 
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
- [x] ~~Make both browsers declarative.~~
- [x] ~~Fix the installation script.~~
- [x] ~~Fix MIME types.~~
- [x] ~~Restructure the flake and make it modular.~~
- [x] ~~Make Vencord fully declarative.~~
- [x] ~~Use the VScodium home-manager module to its fullest extent.~~
- [x] ~~Make Hyprpanel fully declarative; also maybe make a PR that adds home-manager options to that flake.~~
- [x] ~~Switch to standalone home-manager.~~
</details> -->

## credits!
- the vimjoyer youtube channel, for making immensely helpful videos that saved me hours and hours of pain
- https://github.com/NotAShelf/nyx/ — teaching me how many different parts of how nix works, and many bits of code
- https://gitlab.com/Zaney/zaneyos — teaching me how many different parts of how nix works, and several tidbits of code
- https://github.com/MrVivekRajan/Hypr-Dots — The hyprlock config inspiration.
- https://github.com/zDyanTB/HyprNova - The wlogout styling.
- https://github.com/elythh/nixvim — The neovim configuration I use.
- https://github.com/1amSimp1e/dots — i tweaked my starship prompt based off of this guy's prompt
- https://github.com/Tamarindtype/googlish-hyprlock-theme — the hyprlock weather script