{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.dev.rust;
  rustWithExtensions = (pkgs.extend (import inputs.rust-overlay)).rust-bin.stable.latest.default.override {extensions = ["rust-src"];};
in {
  options.hmModules.dev.rust = {
    enable = mkEnableOption "Enable Rust development environment";
  };

  config = mkIf cfg.enable {
    home.packages = [
      rustWithExtensions
      pkgs.rustlings
      pkgs.rust-analyzer
    ];

    home.sessionPath = ["$HOME/.cargo/bin:$PATH"];

    hmModules.cli.shell.extraAliases = {
      cr = "cargo";
      crr = "cargo run";
      crf = "cargo fmt";
      crc = "cargo check";
    };
  };
}
