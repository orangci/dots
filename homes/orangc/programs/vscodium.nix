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

      profiles.default.userSettings = lib.mkForce {
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "explorer.confirmDelete" = false;
        "editor.minimap.enabled" = false;
        "[css]" = {"editor.defaultFormatter" = "vscode.css-language-features";};
        "vscord.status.idle.timeout" = 120;
        "explorer.confirmDragAndDrop" = false;
        "vscord.status.details.text.idle" = "";
        "vscord.behaviour.prioritizeLanguagesOverExtensions" = true;
        "vscord.status.idle.disconnectOnIdle" = true;
        "conventionalCommits.showNewVersionNotes" = false;
        "liveServer.settings.donotVerifyTags" = true;
        "liveServer.settings.donotShowInfoMsg" = true;
        "[html]" = {"editor.defaultFormatter" = "vscode.html-language-features";};
        "[json]" = {"editor.defaultFormatter" = "vscode.json-language-features";};
        "conventionalCommits.promptBody" = false;
        "conventionalCommits.promptFooter" = false;
        "[javascript]" = {"editor.defaultFormatter" = "vscode.typescript-language-features";};
        "extensions.experimental.affinity" = {"asvetliakov.vscode-neovim" = 1;};
        "editor.wordWrap" = "on";
        "editor.fontSize" = 16;
        "[typescriptreact]" = {"editor.defaultFormatter" = "vscode.typescript-language-features";};
        "python.defaultInterpreterPath" = "/home/orangc/code/notes/venv";
        "ruff.lineLength" = 150;
        "ruff.configurationPreference" = "filesystemFirst";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "Stylix";
        "[python]" = {
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "charliermarsh.ruff";
        };
      };

      profiles.default.extensions = with pkgs.vscode-extensions; let
        extensions = []; # catppuccin.catppuccin-vsc-icons catppuccin.catppuccin-vsc
        nixExtensions = lib.optionals config.hmModules.dev.nix.enable [kamadorueda.alejandra];
        rustExtensions = lib.optionals config.hmModules.dev.rust.enable [rust-lang.rust-analyzer];
        pythonExtensions = lib.optionals config.hmModules.dev.python.enable [ms-python.python];
        webdevExtensions = lib.optionals cfg.webdev [bradgashler.htmltagwrap ecmel.vscode-html-css bradlc.vscode-tailwindcss ritwickdey.liveserver];
      in
        extensions ++ webdevExtensions ++ nixExtensions ++ rustExtensions ++ pythonExtensions;
    };
  };
}
