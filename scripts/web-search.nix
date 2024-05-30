{pkgs}:
pkgs.writeShellScriptBin "web-search" ''
   declare -A URLS

   URLS=(
     ["🌎 Search"]="https://search.brave.com/search?q="
     ["❄️  Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
     ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
     ["📜 MAL"]="https://myanimelist.net/anime.php?cat=anime&q="
   )

   # List for rofi
   gen_list() {
     for i in "''${!URLS[@]}"
     do
       echo "$i"
     done
   }

   main() {
     # Pass the list to rofi
     platform=$( (gen_list) | ${pkgs.rofi-wayland}/bin/rofi -dmenu -theme websearch.rasi)

     if [[ -n "$platform" ]]; then
       query=$( (echo ) | ${pkgs.rofi-wayland}/bin/rofi -dmenu -theme websearch.rasi)

       if [[ -n "$query" ]]; then
  url=''${URLS[$platform]}$query
  xdg-open "$url"
       else
  exit
       fi
     else
       exit
     fi
   }

   main

   exit 0
''
