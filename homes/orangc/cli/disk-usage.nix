{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.cli.disk-usage;

  diskUsageApp = pkgs.writeShellApplication {
    name = "disk-usage";
    runtimeInputs = with pkgs; [ripgrep gawk diskus];
    text = ''
      bold=$(tput bold)
      normal=$(tput sgr0)
      green=$(tput setaf 2)
      blue=$(tput setaf 4)

      print_bold() {
        echo "''${bold}''${1}''${normal}"
      }

      print_label() {
        echo "''${bold}''${green}$1''${normal}: $2"
      }

      to_human() {
        local gib
        gib=$(awk "BEGIN {printf \"%.1f\", $1/1073741824}")
        echo "''${gib}GiB"
      }

      echo ""
      print_bold "''${blue}Disk Usage Report"

      total_usage=$(df -h / | rg '/$' | awk '{print $3}' | sed 's/G/GiB/g')

      home_raw=$(diskus "$HOME")
      nix_raw=$(diskus /nix/store)

      home_usage=$(to_human "$home_raw")
      nix_usage=$(to_human "$nix_raw")

      echo ""
      print_label "Total Disk Usage" "$total_usage"
      print_label "Home Folder Size" "$home_usage"
      print_label "Nix Store Size" "$nix_usage"
    '';
  };
in {
  options.hmModules.cli.disk-usage = {
    enable = mkEnableOption "Enable disk usage analysis tools";
  };

  config = mkIf cfg.enable {
    home.packages = [diskUsageApp pkgs.diskus pkgs.dust pkgs.kondo];
  };
}
