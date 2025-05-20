{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

  cfgBat = config.hmModules.cli.bat;
  cfgEza = config.hmModules.cli.eza;
  cfgFd = config.hmModules.cli.fd;
  cfgFetch = config.hmModules.cli.fetch;
  cfgFun = config.hmModules.cli.fun;
  cfgFzf = config.hmModules.cli.fzf;
  cfgRipgrep = config.hmModules.cli.ripgrep;
  cfgZoxide = config.hmModules.cli.zoxide;
in {
  options.hmModules.cli = {
    bat = {enable = mkEnableOption "Enable bat";};
    eza = {enable = mkEnableOption "Enable eza";};
    fd = {enable = mkEnableOption "Enable fd";};
    fetch = {enable = mkEnableOption "Enable fetch programs";};
    fun = {enable = mkEnableOption "Enable fun CLI programs";};
    fzf = {enable = mkEnableOption "Enable fzf";};
    ripgrep = {enable = mkEnableOption "Enable ripgrep";};
    zoxide = {enable = mkEnableOption "Enable zoxide";};
  };

  config = lib.mkMerge [
    (mkIf cfgBat.enable {
      programs.bat.enable = true;
      hmModules.cli.shell.extraAliases = {cat = "bat";};
    })

    (mkIf cfgEza.enable {
      programs.eza.enable = true;
      hmModules.cli.shell.extraAliases = {
        ls = "eza -la --icons=auto";
        l = "eza -a --icons=auto";
      };
    })

    (mkIf cfgFd.enable {
      programs.fd.enable = true;
      hmModules.cli.shell.extraAliases = {find = "fd";};
    })

    (mkIf cfgFetch.enable {
      home.packages = with pkgs; [microfetch nitch onefetch owofetch ipfetch];
    })

    (mkIf cfgFun.enable {
      home.packages = with pkgs; [cmatrix lolcat kittysay uwuify];
    })

    (mkIf cfgFzf.enable {
      programs.fzf.enable = true;
      hmModules.cli.shell.extraAliases = {fuzzy = "fzf";};
    })

    (mkIf cfgRipgrep.enable {
      programs.ripgrep.enable = true;
      hmModules.cli.shell.extraAliases = {grep = "rg";};
    })

    (mkIf cfgZoxide.enable {
      programs.zoxide.enable = true;
      hmModules.cli.shell.extraAliases = {
        cd = "z";
        ".." = "z ..";
      };
    })
  ];
}
