{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hmModules.cli;
in
{
  options.hmModules.cli = {
    fetch.enable = mkEnableOption "Enable fetch programs";
    fun.enable = mkEnableOption "Enable fun CLI programs";
    benchmarking.enable = mkEnableOption "Enable benchmarking tools";
    utilities.enable = mkEnableOption "Enable misc utilities";
    oxidisation.enable = mkEnableOption "Enable drop-in Rust replacements for common CLI tools";
  };

  config = lib.mkMerge [
    (mkIf cfg.fetch.enable {
      home.packages = with pkgs; [
        microfetch
        nitch
        onefetch
        owofetch
        ipfetch
      ];
    })
    (mkIf cfg.fun.enable {
      home.packages = with pkgs; [
        cmatrix
        lolcat
        kittysay
        uwuify
      ];
    })

    (mkIf cfg.oxidisation.enable {
      home.packages = with pkgs; [ sd ];
      programs = {
        bat.enable = true;
        eza.enable = true;
        fd.enable = true;
        fzf.enable = true;
        ripgrep.enable = true;
        zoxide.enable = true;
        ripgrep-all.enable = true;
        tealdeer = {
          enable = true;
          settings.updates = {
            auto_update_interval_hours = 24 * 7;
            auto_update = true;
          };
        };
      };
      hmModules.cli.shell.extraAliases = {
        cat = "bat";
        ls = "eza -la --icons=auto";
        l = "eza --icons=auto";
        lh = "eza -a --icons=auto";
        find = "fd";
        fuzzy = "fzf";
        cd = "z";
        ".." = "z ..";
      };
    })

    (mkIf cfg.benchmarking.enable {
      home.packages = with pkgs; [
        time
        hyperfine
      ];
      hmModules.cli.shell.extraAliases.hf = "hyperfine";
    })

    (mkIf cfg.utilities.enable {
      programs = {
        btop.enable = true;
        pay-respects.enable = true;
      };
      home.packages = with pkgs; [
        tokei
        killall
        tree
        libqalculate
      ];
      hmModules.cli.shell.extraAliases = {
        top = "btop";
      };
    })
  ];
}
