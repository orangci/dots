{
  pkgs,
  config,
  host,
  username,
  lib,
  ...
}: let
  inherit (lib) mkMerge mkEnableOption types mkIf;
  cfg = config.hmModules.cli.shell;
in {
  options.hmModules.cli.shell = {
    enable = mkEnableOption "Enable bash";
    extraAliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Extra shell aliases collected from modules";
    };
  };
  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        eval "$(starship init bash)"
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
        if [ -f /tmp/.current_wallpaper_path ]; then
          export WALLPAPER=$(cat /tmp/.current_wallpaper_path)
        fi
        if [ -f ~/.config/secrets.env ]; then
          export $(grep -v '^#' ~/.config/secrets.env | xargs)
        fi
      '';
      shellAliases = mkMerge [
        {
          mc = "micro";
          copy = "wl-copy";
          paste = "wl-paste";
          qq = "clear";
          tb = "nc termbin.com 9999";
          tr = "trash";
          top = "btop";
          fb = "curl bashupload.com -T";
          filebin = "curl bashupload.com -T";
          ftp = "ncftp";
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
          qn = "clear;nix-shell";
        }
        cfg.extraAliases
      ];
    };
  };
}
