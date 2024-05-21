{ pkgs, config, lib, host, ... }:

let
  palette = config.colorScheme.palette;
  inherit (import ../../hosts/${host}/options.nix) alacritty;
in lib.mkIf (alacritty == true) {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
	padding.x = 15;
	padding.y = 15;
	decorations = "none";
	startup_mode = "Windowed";
	dynamic_title = true;
	opacity = 0.6;
      };
      cursor = {
	style = {
	  shape = "Beam";
	  blinking = "On";
	};
      };
      live_config_reload = true;
      font = {
	normal.family = "JetBrainsMono NFM";
	bold.family = "JetBrainsMono NFM";
	italic.family = "JetBrainsMono NFM";
	bold_italic.family = "JetBrainsMono NFM";
	size = 14;
      };
      colors = {
	bright = {
	  black = "0x${palette.base00}";
	  blue = "0x${palette.base0D}";
	  cyan = "0x${palette.base0C}";
	  green = "0x${palette.base0B}";
	  magenta = "0x${palette.base0E}";
	  red = "0x${palette.base08}";
	  white = "0x${palette.base06}";
	  yellow = "0x${palette.base09}";
	};
	cursor = {
	  cursor = "0x${palette.base06}";
	  text = "0x${palette.base06}";
	};
	normal = {
	  black = "0x${palette.base00}";
	  blue = "0x${palette.base0D}";
	  cyan = "0x${palette.base0C}";
	  green = "0x${palette.base0B}";
	  magenta = "0x${palette.base0E}";
	  red = "0x${palette.base08}";
	  white = "0x${palette.base06}";
	  yellow = "0x${palette.base0A}";
	};
	primary = {
	  background = "0x${palette.base00}";
	  foreground = "0x${palette.base06}";
	};
	draw_bold_text_with_bright_colors = true;
      };
    };
  };
}
