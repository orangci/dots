{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hmModules.dev.rust;

  rustPkgs = import inputs.rust-overlay {
    inherit pkgs;
  };
in {
  options.hmModules.dev.rust = {
    enable = mkEnableOption "Enable Rust development environment";
  };

  config = mkIf cfg.enable {
    home.packages = [
      (rustPkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src"];
      })
      pkgs.rustlings
      pkgs.rust-analyzer
    ];

    # Add cargo bin path to session
    home.sessionPath = ["$HOME/.cargo/bin:$PATH"];

    hmModules.shell.extraAliases = {
      cr = "cargo";
      crr = "cargo run";
      crf = "cargo fmt";
      crc = "cargo check";
    };
  };
}
