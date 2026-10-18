{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.programs.claude;
in
{
  options.hmModules.programs.claude = {
    enable = mkEnableOption "Claude Code";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.claude-code ];

    hmModules.cli.shell.extraAliases = {
      cl = "claude";
      clc = "claude -p /commit";
      clr = "claude --resume";
      clp = "claude --permission-mode auto -p";
      clb = "claude --bg";
      cls = "claude agents";
      cla = "claude attach";
      clk = "claude stop";
      clrm = "claude rm";
      clrs = "claude respawn";
    };
  };
}
