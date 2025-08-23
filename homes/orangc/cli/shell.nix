{
  config,
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkOption
    types
    mkIf
    ;

  cfg = config.hmModules.cli.shell;

  commonAliases = {
    mc = "micro";
    qq = "clear";
    tb = "nc termbin.com 9999";
    fb = "curl bashupload.com -T";
    filebin = "curl bashupload.com -T";
    ftp = "ncftp";
    clock = "date +'The time is %H.%M on a %A. The date is %b %d, %Y C.E.'";
    randompw = "head -c 64 /dev/urandom | base64";
    jl = "micro ~/docs/journal/$(date -I).md";

    # nix stuff
    fr = "nh os switch --hostname ${host} $FLAKE";
    fu = "nh os switch --hostname ${host} --update $FLAKE";
    gcnix = "sudo nh clean all && nix store optimise && sudo journalctl --vacuum-time=1s";
  };

  mergedAliases = mkMerge [
    commonAliases
    cfg.extraAliases
  ];

  sharedInit = ''
    if [ -f /tmp/.current_wallpaper_path ]; then
      export WALLPAPER=$(cat /tmp/.current_wallpaper_path)
    fi
    if [ -f ~/.config/secrets.env ]; then
      export $(grep -v '^#' ~/.config/secrets.env | xargs)
    fi
  '';
in
{
  options.hmModules.cli.shell = {
    program = mkOption {
      type = types.nullOr (
        types.enum [
          "bash"
          "zsh"
          "fish"
        ]
      );
      default = null;
      description = "Shell to use and configure (bash, zsh, fish). Leave null to disable.";
    };
    extraAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra shell aliases collected from modules.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.program == "bash") {
      programs = {
        starship.enableBashIntegration = config.hmModules.cli.starship.enable;
        nix-index.enableBashIntegration = config.hmModules.dev.nix.enable;
        pay-respects.enableBashIntegration = config.hmModules.cli.utilities.enable;
        bash = {
          enable = true;
          enableCompletion = true;
          initExtra = ''
            if [ -f $HOME/.bashrc-personal ]; then
              source $HOME/.bashrc-personal
            fi
            ${sharedInit}
          '';
          shellAliases = mergedAliases;
        };
      };
    })

    (mkIf (cfg.program == "zsh") {
      programs = {
        starship.enableZshIntegration = config.hmModules.cli.starship.enable;
        nix-your-shell.enableZshIntegration = config.hmModules.dev.nix.enable;
        nix-index.enableZshIntegration = config.hmModules.dev.nix.enable;
        pay-respects.enableZshIntegration = config.hmModules.cli.utilities.enable;
        zsh = {
          enable = true;
          enableCompletion = true;
          initExtra = ''
            [[ -f ~/.zshrc-personal ]] && source ~/.zshrc-personal
            ${sharedInit}
          '';
          shellAliases = mergedAliases;
        };
      };
    })

    (mkIf (cfg.program == "fish") {
      programs = {
        nix-your-shell.enableFishIntegration = config.hmModules.dev.nix.enable;
        starship.enableFishIntegration = config.hmModules.cli.starship.enable;
        nix-index.enableFishIntegration = config.hmModules.dev.nix.enable;
        pay-respects.enableFishIntegration = config.hmModules.cli.utilities.enable;
        fish = {
          enable = true;
          interactiveShellInit = ''
            set -g fish_greeting
            if test -f /tmp/.current_wallpaper_path
              set -x WALLPAPER (cat /tmp/.current_wallpaper_path)
            end
            if test -f ~/.config/secrets.env
              for line in (cat ~/.config/secrets.env | grep -v '^#')
                set -x (string split "=" $line)
              end
            end
          '';
          shellAliases = mergedAliases; # shellAbbrs = mergedAliases to use abbrs instead of aliases (untested)
          plugins = [
            {
              name = "puffer";
              src = pkgs.fishPlugins.puffer;
            }
            {
              name = "fish-you-should-use";
              src = pkgs.fishPlugins.fish-you-should-use;
            }
            {
              name = "done";
              src = pkgs.fishPlugins.done;
            }
            {
              name = "colored-man-pages";
              src = pkgs.fishPlugins.colored-man-pages;
            }
          ];
        };
      };
    })
  ];
}
