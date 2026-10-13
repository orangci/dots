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
    enable = mkEnableOption "Python development environment";

    version = mkOption {
      type = types.str;
      default = "python314";
      example = "python312";
      description = "The attribute name of the Python interpreter in nixpkgs to install.";
    };

    mypy = mkEnableOption "mypy (type checker)";
    pyright = mkEnableOption "pyright (language server)";
    ipython = mkEnableOption "IPython for an enhanced REPL";
    enableStartupFile = mkEnableOption "a default PYTHONSTARTUP file";

    defaultVenvDir = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "~/.venvs/default";
      description = "Directory of a default virtualenv to create. It is never activated automatically. Leave it null to not create one.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [
        pkgs.${cfg.version}
        pkgs.uv
        pkgs.ruff
        pkgs.ty
        pkgs.virtualenv
      ]
      ++ lib.optionals cfg.mypy [ pkgs.mypy ]
      ++ lib.optionals cfg.pyright [ pkgs.pyright ]
      ++ lib.optionals cfg.ipython [ pkgs.ipython ];

      hmModules.cli.shell.extraAliases = {
        rf = "ruff";
        rff = "ruff format";
        rfc = "ruff check";
        py = "python3";
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
