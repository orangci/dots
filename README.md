# orange's dots
Hi there! You've stumbled on my dotfiles :D. I run NixOS 23.11 unstable and KDE Plasma 5.27.7 (Wayland). [Here is the NixOS config file](https://github.com/sahmed011/dots/blob/main/configuration.nix).
## Pictures :D
![desktop](https://raw.githubusercontent.com/sahmed011/dots/main/Pictures/Desktop%20Pics/desktopSaturn.png)
----------

## Configuration :computer:

+ **OS**							• [`NixOS`](https://nixos.org/)
+ **DE**							• [`KDE`](https://swaywm.org/)
+ **Bar**							• [`waybar`](https://github.com/Alexays/Waybar)
+ **Dock**							• [`Latte`](https://github.com/KDE/latte-dock)
+ **Cursor**						• [`Oreo Orange Spark`](https://github.com/varlesh/oreo-cursors)
+ **Icons**							• [`Tela`](https://github.com/vinceliuice/Tela-icon-theme)
+ **Colors**							• [`Revontuli`](https://codeberg.org/akselmo/Revontuli/src/branch/main)
+ **Font**							• [`Maple Mono/Jetbrains Mono(Nerd)`](https://github.com/ryanoasis/nerd-fonts)
+ **Shell**							• [`bash`](https://www.gnu.org/software/bash/)
+ **Terminal**						• [`Konsole`](https://konsole.kde.org/)
+ **Editor**						• [`Nano`](https://www.nano-editor.org/)
+ **File Manager**							• [`Dolphin`](https://github.com/KDE/dolphin)
+ **Browser**						• [`firefox`](https://www.mozilla.org/en-US/firefox/new/)
+ **Wallpapers**						• [`Here`](https://github.com/sahmed011/dots/tree/main/Pictures/Wallpapers)

----------

## Installation

1.  First you need to install [`chezmoi`](https://www.chezmoi.io/install/)

```console
$ sh -c "$(curl -fsLS get.chezmoi.io)" # cURL

$ sh -c "$(wget -qO- get.chezmoi.io)" # wGET

$ pacman -S chezmoi # Arch

$ apk add chezmoi # Alpine

$ nix-env -i chezmoi # NixOS & Nix

$ zypper install chezmoi # openSUSE Tumbleweed

$ pkg install chezmoi # Termux & FreeBSD

$ xbps-install -S chezmoi # Void

$ brew install chezmoi # MacOS - Homebrew

$ choco install chezmoi # Windows - Chocolatey

$ snap install chezmoi --classic # Snap
```

2.  Initialize chezmoi with your dotfiles directory:

>   This will check out the repo and any submodules and optionally create a chezmoi config file for you.

```console
$ chezmoi init https://github.com/sahmed011/dots.git
```

3.  Check what changes that chezmoi will make to your directory by running:

```console
$ chezmoi diff
```

4.  If you are happy with the changes that chezmoi will make then run:

```console
$ chezmoi apply -v
```

5.  If you are not happy with the changes to a file then either edit it with:

```console
$ chezmoi edit $FILE
```

6.  Or, invoke a merge tool (by default `vimdiff`) to merge changes between the
current contents of the file, the file in your working copy, and the computed
contents of the file:

```console
$ chezmoi merge $FILE
```

### Update

you can pull and apply the latest changes from this repo with:

```console
$ chezmoi update -v
```
