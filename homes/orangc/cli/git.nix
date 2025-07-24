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
    ;
  cfg = config.hmModules.cli.git;
in
{
  options.hmModules.cli.git = {
    enable = mkEnableOption "Enable Git CLI configuration";
    github = mkEnableOption "Enable GitHub CLI (gh)";
    gitea = mkEnableOption "Enable Gitea CLI (tea)";
    lfs = mkEnableOption "Enable GitHub Large File Storage";

    username = mkOption {
      type = types.str;
      default = "";
      description = "Git user.name";
    };

    email = mkOption {
      type = types.str;
      default = "";
      description = "Git user.email";
    };

    signing = {
      enable = mkEnableOption "Sign Git commits";
      format = mkOption {
        type = types.enum [
          "openpgp"
          "ssh"
        ];
        default = "ssh";
        description = "Git signing format";
      };

      key = mkOption {
        type = types.str;
        default = "";
        description = "Git Signing Key";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.username;
      userEmail = cfg.email;
      delta.enable = true;
      lfs.enable = cfg.lfs;

      signing = mkIf cfg.signing.enable {
        format = cfg.signing.format;
        key = cfg.signing.key;
        signByDefault = true;
      };

      aliases = {
        change-commits = "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" \\$@; }; f";
        # example usage: `change-commits GIT_AUTHOR_NAME "old name" "new name"`
        # or even: `git change-commits GIT_AUTHOR_EMAIL "old@email.com" "new@email.com" HEAD~10..HEAD`
        # HEAD~10..HEAD makes it only select the last ten commits
      };
    };

    hmModules.cli.shell.extraAliases = {
      ga = "git add .";
      commit = "git commit -am";
      gp = "git push";
      gpf = "git push --force";
      push = "git push";
      pull = "git pull";
    };

    home.packages = mkIf cfg.gitea [ pkgs.tea ];
    programs.gh.enable = cfg.github;
  };
}
