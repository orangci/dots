{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.misc.cheatsheet;

  cheatsheetScript = ''
    #!/usr/bin/env bash
    CONFIG="$HOME/.config/hypr/hyprland.conf"

    trim() {
      echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    }

    format_mod() {
      local mod="$1"
      local formatted=()

      mod_upper=$(echo "$mod" | tr '[:lower:]' '[:upper:]')

      if [[ "$mod_upper" == *SUPER* ]]; then
        formatted+=("")
        mod_upper=''${mod_upper//SUPER/}
      fi

      if [[ "$mod_upper" == *SHIFT* ]]; then
        formatted+=("SHIFT")
        mod_upper=''${mod_upper//SHIFT/}
      fi

      if [[ "$mod_upper" == *CONTROL* ]]; then
        formatted+=("CONTROL")
        mod_upper=''${mod_upper//CONTROL/}
      elif [[ "$mod_upper" == *CTRL* ]]; then
        formatted+=("CONTROL")
        mod_upper=''${mod_upper//CTRL/}
      fi

      if [[ "$mod_upper" == *ALT* ]]; then
        formatted+=("ALT")
        mod_upper=''${mod_upper//ALT/}
      fi

      if [[ -n "$mod_upper" ]]; then
        # Append any leftover modifiers just in case
        formatted+=("$mod_upper")
      fi

      local IFS=" + "
      echo "''${formatted[*]}"
    }

    args=()

    while IFS= read -r line; do
      val="''${line#*=}"
      IFS=',' read -ra parts <<< "$val"

      mod=$(trim "''${parts[0]}")
      key=$(trim "''${parts[1]}")
      desc=$(trim "''${parts[2]}")

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
    done < <(grep '^bind' "$CONFIG" | grep -v '^binddm')

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
      --timeout-indicat \
      "''${args[@]}"
  '';
in {
  options.hmModules.misc.cheatsheet = {
    enable = mkEnableOption "Enable cheatsheet script";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.bindd = ["SUPERSHIFT, SLASH, Open Cheatsheet, exec,list-bindings"];
    home.packages = with pkgs; [
      (pkgs.writeShellApplication {
        name = "cheatsheet";
        runtimeInputs = with pkgs; [yad];
        text = cheatsheetScript;
      })
    ];
  };
}
