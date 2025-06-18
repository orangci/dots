{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;
  cfg = config.hmModules.programs.quickshell;
  colours = config.stylix.base16Scheme;
  fonts = config.stylix.fonts;
  quickshellPackage = inputs.quickshell.packages.${pkgs.system}.default;
in
{
  options.hmModules.programs.quickshell = {
    enable = mkEnableOption "Enable quickshell";

    workspaces = mkOption {
      type = types.int;
      default = 10;
      description = "The number of workspaces shown in the bar";
    };

    commands.screenshot = mkOption {
      type = types.str;
      default = "screenshot --area --swappy";
      description = "The command for taking screenshots";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.hmModules.programs.better-control.enable && config.hmModules.styles.qt.enable;
        message = "hmModules.programs.quickshell requires both hmModules.programs.better-control and hmModules.styles.qt modules to be enabled.";
      }
    ];

    home.packages = [
      quickshellPackage
      pkgs.wlsunset
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      pkgs.kdePackages.qt5compat
      pkgs.kdePackages.syntax-highlighting
      pkgs.libqalculate
      pkgs.colloid-kde
    ];
    home.activation.installQuickshell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -d "$HOME/.config/quickshell" ]; then
          chmod -R u+w "$HOME/.config/quickshell"
          rm -rf "$HOME/.config/quickshell"
        fi

        mkdir -p "$HOME/.config/quickshell"
        cp -r ${./config}/* "$HOME/.config/quickshell"
        chmod -R u+w "$HOME/.config/quickshell"

        cat > "$HOME/.config/quickshell/base16.js" <<EOF
        var base00 = "${colours.base00}"
        var base01 = "${colours.base01}"
        var base02 = "${colours.base02}"
        var base03 = "${colours.base03}"
        var base04 = "${colours.base04}"
        var base05 = "${colours.base05}"
        var base06 = "${colours.base06}"
        var base07 = "${colours.base07}"
        var base08 = "${colours.base08}"
        var base09 = "${colours.base09}"
        var base0A = "${colours.base0A}"
        var base0B = "${colours.base0B}"
        var base0C = "${colours.base0C}"
        var base0D = "${colours.base0D}"
        var base0E = "${colours.base0E}"
        var base0F = "${colours.base0F}"
      EOF

        cat > "$HOME/.config/quickshell/config.js" <<EOF
        var bluetooth = "control -b"
        var networking = "control -w"
        var workspacesCount = ${builtins.toString cfg.workspaces}

        var fontMain = "${fonts.sansSerif.name}"
        var fontTitle = "${fonts.sansSerif.name}"
        var fontReading = "${fonts.sansSerif.name}"
        var fontMono = "${fonts.monospace.name}"
        var fontIconMaterial = "Material Symbols Rounded"
        var fontIconNerd = "UbuntuMono Nerd Font Propo"
      EOF
    '';

    wayland.windowManager.hyprland.settings = {
      exec-once = [ "qs" ];
      bindd = [
        "Super, K, Quickshell Overview, global, quickshell:overviewToggleRelease"
        "Super, R, Quickshell Overview, global, quickshell:overviewToggleRelease"
        "Super, Tab, Quickshell Overview, global, quickshell:overviewToggle"
        "Super, A, Open Right Sidebar, global, quickshell:sidebarRightToggle"
        "Ctrl+Alt, Delete, Open Logout Menu, global, quickshell:sessionToggle"
        "SUPER, BACKSLASH, Open Logout Menu, global, quickshell:sessionToggle"
      ];
      layerrule = [
        "animation fade, quickshell:screenCorners"
        "animation slide right, quickshell:sidebarRight"
        "animation slide left, quickshell:sidebarLeft"
        "animation slide top, quickshell:onScreenDisplay"
        "animation fade, quickshell:session"
        "blur, quickshell:session"
        "noanim, quickshell:overview"
      ];
    };
  };
}
