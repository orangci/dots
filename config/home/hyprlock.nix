{
  pkgs,
  config,
  username,
  host,
  ...
}: let
  a = a;
in {
  home.file.".config/hypr/hyprlock.conf".text = ''
    # $text_color = rgba(F6DECEFF)
    # $entry_background_color = rgba(1C110811)
    # $entry_border_color = rgba(A48C7B55)
    # $entry_color = rgba(DDC1AEFF)
    $text_color = rgba(FFFFFFFF)
    $entry_background_color = rgba(33333311)
    $entry_border_color = rgba(3B3B3B55)
    $entry_color = rgba(FFFFFFFF)
    $font_family = JetbrainsMono Nerd Font
    $font_family_clock = JetbrainsMono Nerd Font
    $font_material_symbols = Material Symbols Rounded

    general {
        disable_loading_bar = true
        hide_cursor = true
        grace = 0
        no_fade_in = false
    }
    background {
        monitor =
        path = screenshot
        blur_passes = 3
        blur_size = 10
    }
    # Profile picture
    image {
        monitor =
        size = 120
        position = 0, 45

        path = ~/zaneyos/files/face.jpg
        halign = center
        valign = center

        shadow_passes = 1
    }
    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 2
        dots_size = 0.1
        dots_spacing = 0.3
        outer_color = $entry_border_color
        inner_color = $entry_background_color
        font_color = $entry_color
        # fade_on_empty = true

        position = 0, -80
        halign = center
        valign = center
    }

    label { # Clock
        monitor =
        text = $TIME
        shadow_passes = 1
        shadow_boost = 0.5
        color = $text_color
        font_size = 65
        font_family = $font_family_clock

        position = 0, 300
        halign = center
        valign = center
    }
    # Username
    label {
        monitor =
        position = 10, 0

        text =  $USER
        color = $text_color
        font_size = 16
        font_family = $font_family

        valign = top
        halign = left

        shadow_passes = 1
    }
    # Date
    label {
        monitor =
        position = 0, 200

        text = cmd[update:120000] echo "$(date +'%a %d %B')"
        color = $text_color
        font_size = 30
        font_family = $font_family

        valign = center
        halign = center

        shadow_passes = 1
    }
  '';
}
