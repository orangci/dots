{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    mkMerge
    ;
  cfg = config.hmModules.dev.python;
  svAlias =
    if config.hmModules.cli.shell.program == "fish" then
      "source venv/bin/activate.fish"
    else
      "source venv/bin/activate";
in
{
  options.hmModules.dev.python = {
    enable = mkEnableOption "Enable Python development environment";

    version = mkOption {
      type = types.str;
      default = "python313";
      description = "Python version to use (e.g. 'python312', 'python311')";
    };

    mypy = mkEnableOption "Include mypy (type checker)";
    pyright = mkEnableOption "Include pyright (LSP)";
    ipython = mkEnableOption "Include IPython for enhanced REPL";
    enableStartupFile = mkEnableOption "Include a default PYTHONSTARTUP file";

    defaultVenvDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to default virtualenv to set up (no automatic activation)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages =
        with pkgs;
        [
          (pkgs.${cfg.version})
          uv
          ruff
          virtualenv
        ]
        ++ lib.optionals cfg.mypy [ pkgs.mypy ]
        ++ lib.optionals cfg.pyright [ pkgs.pyright ]
        ++ lib.optionals cfg.ipython [ pkgs.ipython ];

      hmModules.cli.shell.extraAliases = {
        rf = "ruff";
        rff = "ruff format";
        rfc = "ruff check";
        sv = svAlias;
      };
    }

    (mkIf cfg.enableStartupFile {
      home.file.".pythonrc.py".text = ''
        import sys
        import os
        import readline
        import rlcompleter
        readline.parse_and_bind("tab: complete")
        sys.ps1 = ">>> "
        sys.ps2 = "... "
        print("Python interactive shell with tab completion")
      '';

      home.sessionVariables.PYTHONSTARTUP = "${config.home.homeDirectory}/.pythonrc.py";
    })

    (mkIf (cfg.defaultVenvDir != null) {
      home.activation.setupPythonVenv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d "${cfg.defaultVenvDir}" ]; then
          ${pkgs.${cfg.version}}/bin/python -m venv "${cfg.defaultVenvDir}"
        fi
      '';
    })
  ]);
}
