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

    github = mkEnableOption "Enable GitHub CLI (gh)";
    gitea = mkEnableOption "Enable Gitea CLI (tea)";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.username;
      userEmail = cfg.email;

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
      pull = "git push";
    };

    home.packages = mkIf cfg.gitea [ pkgs.tea ];
    programs.gh.enable = cfg.github;
  };
}
