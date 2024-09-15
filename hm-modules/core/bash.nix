{
  pkgs,
  config,
  host,
  username,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.core.bash = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
        if [ -f /tmp/.current_wallpaper_path ]; then
          export WALLPAPER=$(cat /tmp/.current_wallpaper_path)
        fi
      '';
      shellAliases = {
        sv = "sudio nix run github:orxngc/nixvim";
        v = "nix run github:orxngc/nixvim";
        mc = "micro";
        fr = "sudo echo Shikanoko Nokonoko Koshitantan;nh os switch --hostname ${host} /home/${username}/dots";
        frfr = "sudo echo Shikanoko Nokonoko Koshitantan;nh os switch --hostname ${host} /home/${username}/dots;notify-send Rebuilt;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot;notify-send Cleaned;exit";
        fu = "sudo echo Shikanoko Nokonoko Koshitantan;nh os switch --hostname ${host} --update /home/${username}/dots";
        hr = "nh home switch /home/${username}/dots";
        hu = "nh home switch --update /home/${username}/dots";
        hrhr = "sudo echo Shikanoko Nokonoko Koshitantan;nh home switch /home/${username}/dots;notify-send Rebuilt;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot;notify-send Cleaned;exit";
        gcnix = "sudo echo Shikanoko Nokonoko Koshitantan;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        ls = "eza --icons=auto";
        lh = "eza -a --icons=auto";
        l = "eza -l --icons=auto";
        la = "eza -al --icons=auto";
        qq = "clear";
        cat = "bat";
        tr = "trash";
        ".." = "cd ..";
        neofetch = "fastfetch";
        find = "fd";
        spinmal = "bash $HOME/docs/spinPTW.sh";
        ga = "git add .";
        push = "git push";
        top = "btop";
        mktar = "tar -czvf";
        extar = "tar -xzvf";
        ftp = "ncftp";
        list-big-pkgs = "nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n 30";
        list-pkgs = "nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq";
      };
    };
  };
}
