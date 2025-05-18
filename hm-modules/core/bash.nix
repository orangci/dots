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
    programs.zoxide.enable = true;
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
        eval "$(starship init bash)"
      '';
      shellAliases = {
        cd = "z";
        mc = "micro";
        # nix stuff
        list-big-pkgs = "nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n 30";
        list-pkgs = "nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq";
        fr = "sudo echo \"\";nh os switch --hostname ${host} /home/${username}/dots";
        frfr = "sudo echo \"\";nh os switch --hostname ${host} /home/${username}/dots;notify-send Rebuilt;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot;notify-send Cleaned;exit";
        fu = "sudo echo \"\";nh os switch --hostname ${host} --update /home/${username}/dots";
        hr = "nh home switch /home/${username}/dots";
        hu = "nh home switch --update /home/${username}/dots";
        hrhr = "sudo echo \"\";nh home switch /home/${username}/dots;notify-send Rebuilt;nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot;notify-send Cleaned;exit";
        gcnix = "sudo echo \"\";nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        # ls stuff
        ls = "eza --icons=auto";
        lh = "eza -a --icons=auto";
        l = "eza -l --icons=auto";
        la = "eza -al --icons=auto";
        qq = "clear";
        cat = "bat";
        tb = "nc termbin.com 9999";
        tr = "trash";
        ".." = "z ..";
        # fetch stuff
        neofetch = "microfetch";
        fetch = "microfetch";
        # other
        find = "fd";
        top = "btop";
        mktar = "tar -czvf";
        extar = "tar -xzvf";
        fb = "curl bashupload.com -T";
        filebin = "curl bashupload.com -T";
        ftp = "ncftp";
        qn = "clear;nix-shell";
        # time for some rust related aliases
        cr = "cargo";
        crr = "cargo run";
        crf = "cargo fmt";
        crc = "cargo check";
        # typst stuff
        ty = "typst";
        tyc = "typst compile";
        # git
        ga = "git add .";
        gc = "git commit -am";
        gp = "git push";
        gpf = "git push --force";
        push = "git push";
        # python
        rf = "ruff";
        rff = "ruff format";
        rfc = "ruff check";
      };
    };
  };
}
