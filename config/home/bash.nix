{
  config,
  lib,
  pkgs,
  host,
  ...
}: let
  inherit
    (import ../../hosts/${host}/options.nix)
    flakeDir
    flakePrev
    hostname
    flakeBackup
    theShell
    ;
in
  lib.mkIf (theShell == "bash") {
    # Configure Bash
    programs.bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        #  exec Hyprland
        #fi
      '';
      initExtra = ''
        nitch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      sessionVariables = {
        ZANEYOS = true;
        FLAKEBACKUP = "${flakeBackup}";
        FLAKEPREV = "${flakePrev}";
      };
      shellAliases = {
        sv = "sudo nvim";
        flake-rebuild = "nh os switch --hostname ${hostname}";
        flake-update = "nh os switch --hostname ${hostname} --update";
        gcnix = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -a";
        lal = "lsd -al";
        qq = "clear";
        cat = "bat";
        tr = "trash";
        ".." = "cd ..";
        neofetch = "fastfetch";
        gcrec = "rm -rf ~/Videos/snapshots/*";
        find = "fd";
        ztop = "zfxtop";
      };
    };
  }
