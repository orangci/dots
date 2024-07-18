{config, ...}: let
  palette = config.stylix.base16Scheme;
in {
  home.file.".config/hypr/hyprlock.conf".text = ''
      source=/tmp/.current_wallpaper_path_hyprlock
    # BACKGROUND
      background {
          monitor =
          path =$WALLPAPER
          blur_passes = 2
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
      }

      # GENERAL
      general {
          no_fade_in = false
          grace = 0
          disable_loading_bar = false
      }

      # INPUT FIELD
      input-field {
          monitor =
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(30, 30, 46, 0.5)
          font_color = rgb(200, 200, 200)
          fade_on_empty = false
          font_family = Maple Mono
          placeholder_text = <i><span foreground="##ffffff99">Hi, $USER</span></i>
          hide_input = false
          position = 0, -320
          halign = center
          valign = center
      }

      # Hour-Time
      label {
          monitor =
          text = cmd[update:1000] echo -e "$(date +"%H")"
          color = rgba(250, 179, 135, .75)
          font_size = 180
          font_family = Maple Mono
          position = 0, 300
          halign = center
          valign = center
      }

      # Minute-Tine
      label {
          monitor =
          text = cmd[update:1000] echo -e "$(date +"%M")"
          color = rgba(205, 214, 244, .75)
          font_size = 180
          font_family = Maple Mono
          position = 0, 80
          halign = center
          valign = center
      }

    #   # Day
    #   label {
    #       monitor =
    #       text = cmd[update:1000] echo "$(date '+%A,')"
    #       color = rgba(205, 214, 244, .75)
    #       font_size = 30
    #       font_family = Maple Mono
    #       position = -580, -80
    #       halign = center
    #       valign = center
    #   }

    #   # Month-Date
    #   label {
    #       monitor =
    #       text = cmd[update:1000] echo "$(date '+%d %B')"
    #       color = rgba(250, 179, 135, .75)
    #       font_size = 30
    #       font_family = Maple Mono
    #       position = -400, -81.5
    #       halign = center
    #       valign = center
    #   }

      # USER
      image {
          position = 0, -180
          size=200
          border_color=rgba(12, 550, 249,0)
          border_size=1
          halign=center
          path=/home/orangc/dots/config/face.png
          rounding=-1
          valign=center
      }
  '';
}
