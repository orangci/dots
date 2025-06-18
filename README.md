<div align="center">
      <h1>orangc's flake</h1>
      <div>
         <a href="https://github.com/orangci/dots/stargazers"><img src="https://img.shields.io/github/stars/orangci/dots?color=F5BDE6&labelColor=303446&style=for-the-badge&logo=starship&logoColor=F5BDE6"></a>
         <!-- <a href="https://github.com/orangci/dots/"><img src="https://img.shields.io/github/repo-size/orangci/dots?color=C6A0F6&labelColor=303446&style=for-the-badge&logo=github&logoColor=C6A0F6"></a> -->
         <a = href="https://nixos.org"><img src="https://img.shields.io/badge/NixOS-Unstable-blue?style=for-the-badge&logo=NixOS&logoColor=white&label=NixOS&labelColor=303446&color=91D7E3"></a>
         <a href="https://github.com/orangci/dots/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=AGPL3&colorA=313244&colorB=F5A97F&logo=unlicense&logoColor=F5A97F&"/></a>
      </div>
</div>


> [!CAUTION]
> This flake is meant for my personal usage. Use at your own risk. Several modules utilise [secrets](./docs/secrets.md) and are inoperable with them.
> Going through my code for little bits and things to borrow or learn from is totally fine (as long as you respect the license and credit me appropriately).
> This flake is very much a work in progress; I'm constantly working on improving and I have many things planned for it in the future.

Modular NixOS configuration for my machines. Very lightweight! A fresh installation of this flake (with the modules enabled in [anacreon](./hosts/anacreon/config.nix)) will be *18 gigabytes*, which isn't bad at all in my opinion.

Hosts:
- anacreon (PC ~ Hyprland)
- helicon (portable USB, meant to be plugged in to any machine ~ Hyprland)
- urithiru (homelab/server)

<!-- ## screenshots

<details>
<summary>Click to expand.</summary> 

![screenshot](.github/assets/screenshot.png)

</details> -->

## Thank you
- [end-4](https://github.com/end-4) for the Quickshell config
- the vimjoyer youtube channel, for making immensely helpful videos that saved me hours and hours of pain
- https://github.com/fxzzi/NixOhEss - the nvf configuration
- https://github.com/zDyanTB/HyprNova - The wlogout styling.
- https://github.com/1amSimp1e/dots — i tweaked my starship prompt based off of this guy's prompt

## License
- [License: GNU AGPLv3](./LICENSE)
 - The quickshell config is forked from ([this](https://github.com/end-4/dots-hyprland/commit/5d24cc45a3f0e90023b95f8e06ecabb4d987fedc) commit of) [end-4](https://github.com/end-4)'s [dots-hyprland](https://github.com/end-4/dots-hyprland). It is licensed under GNU GPLv3.