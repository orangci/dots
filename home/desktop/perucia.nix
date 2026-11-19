{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf singleton;
  cfg = config.hmModules.desktop.perucia;
  hypr = lib.my.hyprlandLua;
in
{
  imports = singleton inputs.perucia.homeModules.default;
  options.hmModules.desktop.perucia.enable = mkEnableOption "perucia, the desktop shell";

  config = mkIf cfg.enable {
    programs.perucia = {
      enable = true;
      apps = {
        kitty.enable = true;
        gtk.enable = true;
        firefox.enable = true;
        vscodium.enable = true;
        obsidian.enable = true;
      };
      settings = {
        wallpaper = {
          directory = "${config.xdg.userDirs.pictures}/walls";
          rotation = "random";
          interval = 20;
        };
        # pyminaret already announces each prayer; perucia's reminders before it stay
        prayer.notify = false;
        # what the old cheatsheet left off
        cheatsheet.hide = [
          "Move Focus"
          "Move Window"
          "XF86"
          "mouse"
        ];
      };
    };

    # perucia recolours these at runtime; stylix keeps their fonts. fish's colours are a
    # script that would paint the terminal back over perucia's
    stylix.targets = {
      kitty.colors.enable = false;
      gtk.colors.enable = false;
      vscode.colors.enable = false;
      fish.colors.enable = false;
      firefox = {
        colors.enable = false;
        colorTheme.enable = lib.mkForce false;
      };
    };

    # globals reach the shell without spawning anything; the cli is for flags
    wayland.windowManager.hyprland.settings.bind =
      hypr.bindd [
        "SUPER, R, Open Launcher, global, perucia:launcher"
        "SUPER, K, Open Launcher, global, perucia:launcher"
        "SUPER, PERIOD, Emoji Picker, global, perucia:launcherEmoji"
        "SUPER, V, Open Clipboard, global, perucia:launcherClipboard"
        "SUPERSHIFT, V, Clear Clipboard, exec, perucia clipboard clear"
        "SUPER, A, Open Notifications, global, perucia:notifications"
        "SUPERSHIFT, A, Clear Notifications, exec, perucia notifications clear"
        "SUPER, I, Open Control Centre, global, perucia:controlCentre"
        "SUPER, BACKSLASH, Open Session Menu, global, perucia:session"
        "SUPERSHIFT, SLASH, Open Cheatsheet, global, perucia:cheatsheet"
        "ALT, Tab, Switch Window, global, perucia:altTab"
        "ALTSHIFT, Tab, Switch Window Back, global, perucia:altTabBack"
        "SUPER, S, Area Screenshot, global, perucia:screenshotArea"
        "SUPERSHIFT, S, Area Screenshot (With Editor), exec, perucia screenshot area --edit"
        "SUPERSHIFT, T, Copy Text From Screenshot, global, perucia:screenshotText"
        "SUPERALT, C, Colour Picker, global, perucia:pickColour"
        "SUPER, O, Start/Stop Screen Recording, global, perucia:recordScreen"
        "SUPERCONTROL, O, Record Area, global, perucia:recordArea"
        "SUPERSHIFT, O, Stop Screen Recording, global, perucia:recordStop"
        "SUPER, L, Lock Screen, global, perucia:lock"
        ",XF86HomePage, Lock Screen, global, perucia:lock"
        "SUPER, APOSTROPHE, Randomise Wallpaper, global, perucia:wallpaperRandom"
        "SUPERSHIFT, APOSTROPHE, Pick Wallpaper, global, perucia:launcherWallpapers"
        "SUPERSHIFT, M, Mute Microphone, global, perucia:micMute"
        "SUPER, P, Pause Media, global, perucia:playPause"
        "SUPERSHIFT, P, Next Media, global, perucia:next"
        "SUPERALT, P, Previous Media, global, perucia:previous"
        ",XF86AudioMute, Mute Audio, global, perucia:mute"
        ",XF86AudioPlay, Play Media, global, perucia:playPause"
        ",XF86AudioPause, Pause Media, global, perucia:playPause"
        ",XF86AudioNext, Next Media, global, perucia:next"
        ",XF86AudioPrev, Previous Media, global, perucia:previous"
      ]
      ++ hypr.bindld [ ",Print, Fullscreen Screenshot, exec, perucia screenshot screen --edit" ]
      # brightness goes through perucia too, or the osd never hears of it
      ++ hypr.bindde [
        ",XF86AudioRaiseVolume, Raise Volume, global, perucia:volumeUp"
        ",XF86AudioLowerVolume, Lower Volume, global, perucia:volumeDown"
        ",XF86MonBrightnessUp, Raise Brightness, global, perucia:brightnessUp"
        ",XF86MonBrightnessDown, Lower Brightness, global, perucia:brightnessDown"
      ];
  };
}
