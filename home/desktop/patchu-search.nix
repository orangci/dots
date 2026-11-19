{
  config,
  flakeSettings,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.desktop.patchuSearch;
  perucia = config.hmModules.desktop.perucia.enable;
  # the key is a sops secret owned by orangc (see hosts/komashi/config.nix)
  patchuSearch = pkgs.writeShellApplication {
    name = "patchu-search";
    runtimeInputs = with pkgs; [
      curl
      jq
      wl-clipboard
      libnotify
      (if perucia then config.programs.perucia.package else walker)
    ];
    text = ''
      host=https://patchu.${flakeSettings.domains.primary}
      query=$(${
        # no items on stdin, so whatever is typed comes back
        if perucia then
          ''perucia dmenu -p "patchu search" </dev/null''
        else
          ''walker --dmenu --inputonly --placeholder "patchu search"''
      }) || exit 0
      [ -n "$query" ] || exit 0
      # memes unless the query names a collection itself
      case $query in
        *collection:*) ;;
        *) query="collection:memes $query" ;;
      esac

      key=$(< /run/secrets/patchu-api-key)
      # same grammar as the app, defaults and all, since the server parses it
      link=$(curl -fsS -G "$host/api/search" \
        -H "Authorization: Bearer $key" \
        --data-urlencode "q=$query" \
        --data-urlencode "limit=1" \
        | jq -r --arg host "$host" '.items[0] | if . == null then empty else (.public // ($host + .file)) end') || {
        notify-send -a patchu "Search failed" "$query"
        exit 1
      }

      if [ -z "$link" ]; then
        notify-send -a patchu "No results" "$query"
        exit 0
      fi
      wl-copy "$link"
      notify-send -a patchu "Copied link" "$link"
    '';
  };
in
{
  options.hmModules.desktop.patchuSearch.enable =
    mkEnableOption "patchu-search, which copies a link to patchu's best match for a query";

  config = mkIf cfg.enable {
    home.packages = [ patchuSearch ];
    wayland.windowManager.hyprland.settings.bind = lib.my.hyprlandLua.bindd [
      "SUPERSHIFT, B, Patchu Search, exec, patchu-search"
    ];
    wayland.windowManager.niri.settings.binds."Mod+Shift+B" = {
      _props.hotkey-overlay-title = "Patchu Search";
      spawn = [ "patchu-search" ];
    };
  };
}
