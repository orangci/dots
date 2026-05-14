{ flakeSettings, lib, ... }:
let
  inherit (lib) singleton;
in
{
  config.modules.services.webpages.main.redirects = [
    # subdomains
    {
      sources = [
        "blog"
        "notes"
      ];
      target = "https://notes.${flakeSettings.domains.primary}";
    }
    {
      sources = singleton "n";
      target = "https://notes.${flakeSettings.domains.primary}/notes";
    }
    {
      sources = singleton "p";
      target = "https://bin.${flakeSettings.domains.primary}";
    }
    {
      sources = singleton "g";
      target = "https://git.${flakeSettings.domains.primary}/c";
    }
    {
      sources = singleton "z";
      target = "https://zip.${flakeSettings.domains.primary}/z";
    }
    {
      sources = singleton "u";
      target = "https://zip.${flakeSettings.domains.primary}/u";
    }
    {
      sources = singleton "f";
      target = "https://files.${flakeSettings.domains.primary}";
    }
    {
      sources = singleton "m";
      target = "https://files.${flakeSettings.domains.primary}/media/memes";
    }
    {
      sources = singleton "salah";
      target = "https://salah.${flakeSettings.domains.primary}";
    }
    {
      sources = singleton "takina";
      target = "https://takina.${flakeSettings.domains.primary}";
    }
    # old versions of the site
    {
      sources = singleton "v2";
      target = "https://vercel.uwu.is-a.dev";
    }
    {
      sources = singleton "v3";
      target = "https://8e6ebe40.orangc.pages.dev";
    }

    # socials
    {
      sources = singleton "anime";
      target = "https://myanimelist.net/animelist/orangc";
    }
    {
      sources = singleton "animeschedule";
      target = "https://animeschedule.net/users/orange";
    }
    {
      sources = [
        "anilist"
        "al"
      ];
      target = "https://anilist.co/user/orangc";
    }
    {
      sources = singleton "backloggd";
      target = "https://www.backloggd.com/u/orangc";
    }
    {
      sources = [
        "bluesky"
        "bsky"
      ];
      target = "https://bsky.app/profile/orang.ci";
    }
    {
      sources = singleton "discord";
      target = "https://discord.com/users/961063229168164864";
    }
    {
      sources = [
        "github"
        "gh"
      ];
      target = "https://github.com/orangci";
    }
    {
      sources = singleton "goodreads";
      target = "https://www.goodreads.com/orangc";
    }
    {
      sources = singleton "hardcover";
      target = "https://hardcover.app/@ci";
    }
    {
      sources = singleton "letterboxd";
      target = "https://letterboxd.com/orangc";
    }
    {
      sources = [
        "mal"
        "myanimelist"
      ];
      target = "https://myanimelist.net/profile/orangc";
    }
    {
      sources = singleton "manga";
      target = "https://myanimelist.net/mangalist/orangc";
    }
    {
      sources = singleton "mastodon";
      target = "https://mastodon.social/@orangc";
    }
    {
      sources = singleton "matrix";
      target = "https://matrix.to/#/@c:${flakeSettings.domains.primary}";
    }
    {
      sources = [
        "namemc"
        "minecraft"
        "mc"
      ];
      target = "https://namemc.com/profile/orangci.1";
    }
    {
      sources = singleton "osu";
      target = "https://osu.ppy.sh/users/36686648";
    }
    {
      sources = singleton "reddit";
      target = "https://reddit.com/u/orangc";
    }
    {
      sources = singleton "steam";
      target = "https://steamcommunity.com/id/orangc";
    }
    {
      sources = singleton "twitch";
      target = "https://www.twitch.tv/orangci";
    }
    {
      sources = singleton "wakatime";
      target = "https://wakatime.com/@orangc";
    }
    {
      sources = [
        "wikispeedruns"
        "wsr"
      ];
      target = "https://wikispeedruns.com/profile/ci";
    }
    {
      sources = [
        "x"
        "twitter"
      ];
      target = "https://x.com/orangcii";
    }
    {
      sources = [
        "yt"
        "youtube"
      ];
      target = "https://www.youtube.com/@orangc";
    }

    # walls
    {
      sources = singleton "walls";
      target = "https://files.${flakeSettings.domains.primary}/media/walls/?nombar&noacci&nosrvi&nonav&nolbar&noctxb&norepl&grid";
    }
    {
      sources = [
        "walls-catppuccin-mocha"
        "wallsppuccin"
      ];
      target = "https://files.${flakeSettings.domains.primary}/media/walls-catppuccin-mocha/?nombar&noacci&nosrvi&nonav&nolbar&noctxb&norepl&grid";
    }

    # other
    {
      sources = singleton "license";
      target = "https://www.gnu.org/licenses/agpl-3.0.en.html";
    }
    {
      sources = singleton "source";
      target = "https://git.${flakeSettings.domains.primary}/c/webpage";
    }
    {
      sources = singleton "analytics";
      target = "https://umami.${flakeSettings.domains.primary}/share/TnoNTAvEwjDueE7F/orangc.net";
    }
    {
      sources = singleton "nohello";
      target = "https://notes.${flakeSettings.domains.primary}/notes/internet-etiquette#no-quothelloquot";
    }
    {
      sources = singleton "uses";
      target = "https://notes.${flakeSettings.domains.primary}/notes/uses";
    }
    {
      sources = [
        "dots"
        "flake"
      ];
      target = "https://flake.${flakeSettings.domains.primary}";
    }
  ];
}
