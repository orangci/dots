{ pkgs, config, lib, host, ... }:

let
  palette = config.colorScheme.palette;
  inherit (import ../../hosts/${host}/options.nix) wezterm;
in lib.mkIf (wezterm == true) {
  home.packages = with pkgs; [
    pkgs.wezterm
  ];

  home.file.".config/wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'

    -- This will hold the configuration.
    local config = wezterm.config_builder()

    config.colors = {
      foreground = '#${palette.base05}',
      background = '#${palette.base00}',

      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_bg = '#${palette.base07}',
      -- Overrides the text color when the current cell is occupied by the cursor
      cursor_fg = '#${palette.base00}',
      -- Specifies the border color of the cursor when the cursor style is set to Block,
      -- or the color of the vertical or horizontal bar when the cursor style is set to
      -- Bar or Underline.
      cursor_border = '#${palette.base07}',

      -- the foreground color of selected text
      selection_fg = '#${palette.base01}',
      -- the background color of selected text
      selection_bg = '#${palette.base0D}',

      -- The color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = '#222222',

      -- The color of the split lines between panes
      split = '#444444',

      ansi = {
	'#${palette.base00}',
	'#${palette.base0C}',
	'#${palette.base09}',
	'#${palette.base0A}',
	'#${palette.base0F}',
	'#${palette.base0E}',
	'#${palette.base07}',
	'#${palette.base05}',
      },
      brights = {
	'#${palette.base01}',
	'#${palette.base0C}',
	'#${palette.base09}',
	'#${palette.base0B}',
	'#${palette.base03}',
	'#${palette.base0E}',
	'#${palette.base0D}',
	'#${palette.base05}',
      },

      -- Arbitrary colors of the palette in the range from 16 to 255
      indexed = { [136] = '#af8700' },

      -- Since: 20220319-142410-0fcdea07
      -- When the IME, a dead key or a leader key are being processed and are effectively
      -- holding input pending the result of input composition, change the cursor
      -- to this color to give a visual cue about the compose state.
      compose_cursor = 'orange',

      -- Colors for copy_mode and quick_select
      -- available since: 20220807-113146-c2fee766
      -- In copy_mode, the color of the active text is:
      -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
      -- 2. selection_* otherwise
      copy_mode_active_highlight_bg = { Color = '#000000' },
      -- use `AnsiColor` to specify one of the ansi color palette values
      -- (index 0-15) using one of the names "Black", "Maroon", "Green",
      --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
      -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
      copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
      copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
      copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

      quick_select_label_bg = { Color = 'peru' },
      quick_select_label_fg = { Color = '#ffffff' },
      quick_select_match_bg = { AnsiColor = 'Navy' },
      quick_select_match_fg = { Color = '#ffffff' },
    }

    wezterm.font_with_fallback({
      -- /.local/share/fonts/JetBrainsMono.ttf, FontConfig
      "JetBrains Mono",

      -- /.local/share/fonts/Symbols-Regular.ttf, FontConfig
      "Symbols Nerd Font Mono",

      -- /.local/share/fonts/NotoColorEmoji.ttf, FontConfig
      -- Assumed to have Emoji Presentation
      -- Pixel sizes: [128]
      "Noto Color Emoji",

    })

    config.enable_wayland = false

    -- and finally, return the configuration to wezterm
    return config
  '';
}
