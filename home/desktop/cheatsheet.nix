{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption singleton mkIf;
  cfg = config.hmModules.desktop.cheatsheet;

  cheatsheetScript = ''
    #!/usr/bin/env bash
    trim() {
      echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    }

    # hyprctl gives the modifiers as a bitmask: 1 shift, 4 ctrl, 8 alt, 64 super
    format_mod() {
      local mask="$1"
      local formatted=()

      (( mask & 64 )) && formatted+=("")
      (( mask & 1 )) && formatted+=("SHIFT")
      (( mask & 4 )) && formatted+=("CONTROL")
      (( mask & 8 )) && formatted+=("ALT")

      local out=""
      for m in "''${formatted[@]}"; do
        out+="''${out:+ + }$m"
      done
      echo "$out"
    }

    args=()

    while IFS=$'\t' read -r mod key desc; do

      # Skip unwanted keybinds/descriptions
      if [[ "$desc" == Move\ To\ Workspace* ]] || \
         [[ "$desc" == Move\ Window\ To\ Workspace* ]] || \
         [[ "$desc" == Move\ Focus* ]] || \
         [[ "$desc" == Move\ Window* ]] || \
         [[ "$key" == XF86* ]] || \
         [[ "$key" == mouse* ]]; then
        continue
      fi

      mod=$(format_mod "$mod")

      if [[ -z "$mod" ]]; then
        keybind="$key"
      else
        keybind="$mod + $key"
      fi

      args+=("$keybind" "$desc")
    done < <(hyprctl binds -j | jq -r '.[] | select(.description != "") | [.modmask, .key, .description] | @tsv')

    if [[ ''${#args[@]} -eq 0 ]]; then
      yad --title="Hyprland Keybindings" --text="No keybindings found." --button=OK
      exit 0
    fi

    yad --width=950 --height=620 \
      --center \
      --fixed \
      --title="Keybindings" \
      --no-buttons \
      --list \
      --column=Key: \
      --column=Description: \
      --column=Key: \
      --column=Description: \
      --timeout=90 \
      --timeout-indicator=bottom \
      "''${args[@]}"
  '';
in
{
  options.hmModules.desktop.cheatsheet.enable = mkEnableOption "cheatsheet script";
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPERSHIFT, SLASH, Open Cheatsheet, exec, cheatsheet"
    ];
    home.packages = singleton (
      pkgs.writeShellApplication {
        name = "cheatsheet";
        runtimeInputs = with pkgs; [
          yad
          jq
        ];
        text = cheatsheetScript;
      }
    );
  };
}
