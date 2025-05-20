{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.hmModules.programs.vscodium;
in {
  options.hmModules.programs.vscodium = {
    enable = mkEnableOption "Enable VSCodium";

    webdev = mkOption {
      type = types.bool;
      default = false;
      description = "Enable web development extensions.";
    };
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default.extensions = with pkgs.vscode-extensions; let
        extensions = [catppuccin.catppuccin-vsc-icons catppuccin.catppuccin-vsc];
        nixExtensions = lib.optionals config.hmModules.dev.nix.enable [kamadorueda.alejandra];
        rustExtensions = lib.optionals config.hmModules.dev.rust.enable [rust-lang.rust-analyzer];
        pythonExtensions = lib.optionals config.hmModules.dev.python.enable [ms-python.python];
        webdevExtensions = lib.optionals cfg.webdev [bradgashler.htmltagwrap ecmel.vscode-html-css bradlc.vscode-tailwindcss ritwickdey.liveserver];
      in
        extensions ++ webdevExtensions ++ nixExtensions ++ rustExtensions ++ pythonExtensions;
    };
  };
}
