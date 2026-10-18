{
  config,
  lib,
  pkgs,
  flakeSettings,
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
    enable = mkEnableOption "Git CLI configuration";
    github = mkEnableOption "GitHub CLI (gh)";
    gitea = mkEnableOption "Gitea CLI (tea)";
    lfs = mkEnableOption "GitHub Large File Storage";
    pre-commit = mkEnableOption "pre-commit";

    username = mkOption {
      type = types.str;
      default = "";
      example = "orangc";
      description = "The name Git attaches to your commits (`user.name`).";
    };

    email = mkOption {
      type = types.str;
      default = "";
      example = "you@example.com";
      description = "The email address Git attaches to your commits (`user.email`).";
    };

    signing = {
      enable = mkEnableOption "signing of Git commits";
      format = mkOption {
        type = types.enum [
          "openpgp"
          "ssh"
        ];
        default = "openpgp";
        description = "The kind of key used to sign commits. `openpgp` uses a GPG key, `ssh` uses an SSH key.";
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "ABCDEF0123456789ABCDEF0123456789ABCDEF01";
        description = "The key to sign commits with. For `openpgp` this is a GPG key ID or fingerprint, for `ssh` it is the path to a public key.";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      gh.enable = cfg.github;
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
      git = {
        enable = true;
        lfs.enable = cfg.lfs;
        package = pkgs.gitFull;
        signing = mkIf cfg.signing.enable {
          inherit (cfg.signing) format;
          inherit (cfg.signing) key;
          signByDefault = true;
        };

        settings = {
          user.name = cfg.username;
          user.email = cfg.email;
          credential.helper = "store";
          push.autoSetupRemote = true;
          format.signOff = true;
          alias = {
            change-commits = "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" \\$@; }; f";
            # example usage: `change-commits GIT_AUTHOR_NAME "old name" "new name"`
            # or even: `git change-commits GIT_AUTHOR_EMAIL "old@email.com" "new@email.com" HEAD~10..HEAD`
            # HEAD~10..HEAD makes it only select the last ten commits
          };
          sendemail = {
            smtpserver = "smtp.purelymail.com";
            smtpuser = "c@${flakeSettings.domains.email}";
            smtpencryption = "ssl";
            smtpserverport = 465;
            annotate = true;
          };
        };
      };
    };

    hmModules.cli.shell.extraAliases = {
      ga = "git add .";
      commit = "git commit -sm";
      amend = "git commit --amend --no-edit";
      gp = "git push";
      gs = "git switch";
      gpf = "git push --force-with-lease";
      push = "git push";
      pull = "git pull";
      gd = "git diff | bat -p";
      gt = "git status";
      gl = "git log --oneline -50";
      gr = "git restore";
      grs = "git restore --staged";
      grb = "git rebase";
      prc = "pre-commit";
      prca = "pre-commit run --all-files";
    };

    home.packages =
      with pkgs;
      lib.optionals cfg.gitea [ tea ]
      ++ lib.optionals cfg.pre-commit [
        pre-commit
        pre-commit-hook-ensure-sops
      ];
  };
}
