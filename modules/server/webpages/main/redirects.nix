{ config, flakeSettings, ... }:
{
  config.modules.server.webpages.main.redirects = [
    # subdomains
    {
      source = "blog";
      target = "https://notes.${flakeSettings.domains.primary}";
    }
    {
      source = "notes";
      target = "https://notes.${flakeSettings.domains.primary}";
    }
    {
      source = "n";
      target = "https://notes.${flakeSettings.domains.primary}/notes";
    }
    {
      source = "p";
      target = "https://bin.${flakeSettings.domains.primary}";
    }
    {
      source = "g";
      target = "https://git.${flakeSettings.domains.primary}/c";
    }
    {
      source = "z";
      target = "https://zip.${flakeSettings.domains.primary}/z";
    }
    {
      source = "u";
      target = "https://zip.${flakeSettings.domains.primary}/u";
    }
    {
      source = "f";
      target = "https://files.${flakeSettings.domains.primary}";
    }
    {
      source = "m";
      target = "https://files.${flakeSettings.domains.primary}/media/memes";
    }
    {
      source = "salah";
      target = "https://salah.${flakeSettings.domains.primary}";
    }
    {
      source = "takina";
      target = "https://takina.${flakeSettings.domains.primary}";
    }
    # old versions of the site
    {
      source = "v2";
      target = "https://vercel.uwu.is-a.dev";
    }
    {
      source = "v3";
      target = "https://8e6ebe40.orangc.pages.dev";
    }

    # socials
    {
      source = "anime";
      target = "https://myanimelist.net/animelist/orangc";
    }
    {
      source = "animeschedule";
      target = "https://animeschedule.net/users/orange";
    }
    {
      source = "anilist";
      target = "https://anilist.co/user/orangc";
    }
    {
      source = "backloggd";
      target = "https://www.backloggd.com/u/orangc";
    }
    {
      source = "bluesky";
      target = "https://bsky.app/profile/orang.ci";
    }
    {
      source = "discord";
      target = "https://discord.com/users/961063229168164864";
    }
    {
      source = "github";
      target = "https://github.com/orangci";
    }
    {
      source = "goodreads";
      target = "https://www.goodreads.com/orangc";
    }
    {
      source = "gh";
      target = "https://github.com/orangci";
    }
    {
      source = "hardcover";
      target = "https://hardcover.app/@ci";
    }
    {
      source = "letterboxd";
      target = "https://letterboxd.com/orangc";
    }
    {
      source = "mal";
      target = "https://myanimelist.net/profile/orangc";
    }
    {
      source = "manga";
      target = "https://myanimelist.net/mangalist/orangc";
    }
    {
      source = "mastodon";
      target = "https://mastodon.social/@orangc";
    }
    {
      source = "matrix";
      target = "https://matrix.to/#/@c:${flakeSettings.domains.primary}";
    }
    {
      source = "mc";
      target = "https://namemc.com/profile/orangci.1";
    }
    {
      source = "minecraft";
      target = "https://namemc.com/profile/orangci.1";
    }
    {
      source = "myanimelist";
      target = "https://myanimelist.net/profile/orangc";
    }
    {
      source = "namemc";
      target = "https://namemc.com/profile/orangci.1";
    }
    {
      source = "osu";
      target = "https://osu.ppy.sh/users/36686648";
    }
    {
      source = "reddit";
      target = "https://reddit.com/u/orangc";
    }
    {
      source = "steam";
      target = "https://steamcommunity.com/id/orangc";
    }
    {
      source = "twitch";
      target = "https://www.twitch.tv/orangci";
    }
    {
      source = "twitter";
      target = "https://x.com/orangcii";
    }
    {
      source = "wakatime";
      target = "https://wakatime.com/@orangc";
    }
    {
      source = "wikispeedruns";
      target = "https://wikispeedruns.com/profile/ci";
    }
    {
      source = "wsr";
      target = "https://wikispeedruns.com/profile/ci";
    }
    {
      source = "x";
      target = "https://x.com/orangcii";
    }
    {
      source = "yt";
      target = "https://www.youtube.com/@orangc";
    }
    {
      source = "youtube";
      target = "https://www.youtube.com/@orangc";
    }
    # walls
    {
      source = "walls";
      target = "https://files.${flakeSettings.domains.primary}/media/walls/?nombar&noacci&nosrvi&nonav&nolbar&noctxb&norepl&grid";
    }
    {
      source = "walls-catppuccin-mocha";
      target = "https://files.${flakeSettings.domains.primary}/media/walls-catppuccin-mocha/?nombar&noacci&nosrvi&nonav&nolbar&noctxb&norepl&grid";
    }
    {
      source = "wallsppuccin";
      target = "https://files.${flakeSettings.domains.primary}/media/walls-catppuccin-mocha/?nombar&noacci&nosrvi&nonav&nolbar&noctxb&norepl&grid";
    }
    # friends: not very complete list, sadly. if you somehow see this and have me added on discord or elsewhere, you can remind me to add you here
    {
      source = "fr";
      target = "/friends";
    }
    {
      source = "friends/iostpa";
      target = "https://iostpa.com";
    }
    {
      source = "friends/caesus";
      target = "https://crispy-caesus.eu";
    }
    {
      source = "friends/dibster";
      target = "https://dibster.dev";
    }
    {
      source = "friends/dragsbruh";
      target = "https://furina.is-a.dev";
    }
    {
      source = "friends/fazzi";
      target = "https://gitlab.com/fazzi";
    }
    {
      source = "friends/fxzzi";
      target = "https://gitlab.com/fazzi";
    }
    {
      source = "friends/end";
      target = "https://github.com/end-4";
    }
    {
      source = "friends/end-4";
      target = "https://github.com/end-4";
    }
    {
      source = "friends/ufufurina";
      target = "https://furina.is-a.dev";
    }
    {
      source = "friends/furina";
      target = "https://furina.is-a.dev";
    }
    {
      source = "friends/quince";
      target = "https://quincetart10.is-a.dev";
    }
    {
      source = "friends/linker";
      target = "https://linker.sh";
    }
    {
      source = "friends/mahir";
      target = "https://molai.dev";
    }
    {
      source = "friends/matei";
      target = "https://devmatei.is-a.dev";
    }
    {
      source = "friends/okcoder";
      target = "https://okcoder1.is-a.dev";
    }
    {
      source = "friends/outfoxxed";
      target = "https://outfoxxed.me";
    }
    {
      source = "friends/raf";
      target = "https://notashelf.dev";
    }
    {
      source = "friends/notashelf";
      target = "https://notashelf.dev";
    }
    {
      source = "friends/satindar";
      target = "https://satindar.is-a.dev";
    }
    {
      source = "friends/satria";
      target = "https://satr14.my.id";
    }
    {
      source = "friends/satr14";
      target = "https://satr14.my.id";
    }
    {
      source = "friends/stef";
      target = "https://stefdp.com";
    }
    {
      source = "friends/stefdp";
      target = "https://stefdp.com";
    }
    {
      source = "friends/stefan";
      target = "https://lungustefan.com";
    }
    {
      source = "friends/arrtea";
      target = "https://arrtea.is-a.dev";
    }
    {
      source = "friends/tea";
      target = "https://arrtea.is-a.dev";
    }
    {
      source = "friends/trollm8";
      target = "https://trollm8.xyz";
    }
    {
      source = "friends/ukriu";
      target = "https://ukriu.com";
    }
    {
      source = "friends/vwinter";
      target = "https://vwinter.moe";
    }
    {
      source = "friends/winter";
      target = "https://vwinter.moe";
    }
    {
      source = "friends/william";
      target = "https://wharrison.com.au";
    }
    {
      source = "friends/yunexiz";
      target = "https://y.is-a.dev";
    }

    # other
    {
      source = "license";
      target = "https://www.gnu.org/licenses/agpl-3.0.en.html";
    }
    {
      source = "source";
      target = "https://git.${flakeSettings.domains.primary}/c/webpage";
    }
    {
      source = "analytics";
      target = "https://umami.${flakeSettings.domains.primary}/share/TnoNTAvEwjDueE7F/orangc.net";
    }
    {
      source = "nohello";
      target = "https://notes.${flakeSettings.domains.primary}/notes/internet-etiquette#no-quothelloquot";
    }
    {
      source = "uses";
      target = "https://notes.${flakeSettings.domains.primary}/notes/uses";
    }
    {
      source = "dots";
      target = "https://git.${flakeSettings.domains.primary}/c/dots";
    }
    {
      source = "flake";
      target = "https://git.${flakeSettings.domains.primary}/c/dots";
    }
  ];
}
