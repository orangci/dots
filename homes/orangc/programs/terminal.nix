{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.hmModules.programs.terminal;
in {
  options.hmModules.programs.terminal = {
    enable = mkEnableOption "Enable terminal emulator";

    emulator = mkOption {
      type = types.enum ["kitty" "foot" "alacritty"];
      default = "kitty";
      description = "Which terminal emulator to enable.";
    };
  };

  config = mkIf cfg.enable (
    lib.mkMerge [
      (mkIf (cfg.emulator == "kitty") {
        wayland.windowManager.hyprland.settings.bindd = ["SUPER, Return, Launch Terminal, exec, kitty"];
        programs.kitty = {
          enable = true;
          settings = {
            scrollback_lines = 2000;
            wheel_scroll_min_lines = 1;
            window_padding_width = 4;
            confirm_os_window_close = 0;
          };
        };
      })

      (mkIf (cfg.emulator == "foot") {
        wayland.windowManager.hyprland.settings.bindd = ["SUPER, Return, Launch Terminal, exec, foot"];
        programs.foot.enable = true;
      })

      (mkIf (cfg.emulator == "alacritty") {
        wayland.windowManager.hyprland.settings.bindd = ["SUPER, Return, Launch Terminal, exec, alacritty"];
        programs.alacritty.enable = true;
      })
    ]
  );
}
