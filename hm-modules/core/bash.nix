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
        # Function to create a tar archive
        mktar() {
            local input_files=""
            local output_file=""

            # Parse arguments
            while [[ "$#" -gt 0 ]]; do
                case $1 in
                    -i|--input) input_files="$2"; shift ;;
                    -o|--output) output_file="$2"; shift ;;
                    *) echo "Unknown parameter passed: $1"; return 1 ;;
                esac
                shift
            done

            # Check if input files and output file are provided
            if [[ -z "$input_files" || -z "$output_file" ]]; then
                echo "Usage: mktar -i <input_files> -o <output_file.tar>"
                return 1
            fi

            # Create the tar archive
            tar -cvf "$output_file" $input_files
        }

        # Function to extract a tar archive
        extar() {
            local tar_file="$1"
            local dest_folder="''${2:-.}"  # Defaults to current folder if no destination is provided

            # Check if tar file is provided
            if [[ -z "$tar_file" ]]; then
                echo "Usage: extar <tar_file> [destination_folder]"
                return 1
            fi

            # Extract the tar archive
            tar -xvf "$tar_file" -C "$dest_folder"
        }

        timer() {
            local seconds
            seconds=$(awk "BEGIN {print $1 * 60}")
            sleep "$seconds" && notify-send "⏰ Timer: $1 minute(s) are up!"
        }


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
        # sv = "sudio nix run github:orangci/nixvim";
        # v = "nix run github:orangci/nixvim";
        sv = "sudo nvim";
        cd = "z";
        v = "nvim";
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
        tb = "nc termbin.com 9999";
        tr = "trash";
        ".." = "z ..";
        neofetch = "microfetch";
        fetch = "microfetch";
        find = "fd";
        spinmal = "bash $HOME/docs/spinPTW.sh";
        ga = "git add .";
        push = "git push";
        top = "btop";
        mktar = "tar -czvf";
        extar = "tar -xzvf";
        fb = "curl bashupload.com -T";
        filebin = "curl bashupload.com -T";
        ftp = "ncftp";
        list-big-pkgs = "nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n 30";
        list-pkgs = "nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq";
        qn = "clear;nix-shell";
      };
    };
  };
}
