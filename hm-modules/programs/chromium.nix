{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.hmModules.programs.chromium = mkOption {
    enabled = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = {
    programs.chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock
        "clngdbkpkpeebahjckkjfobafhncgmne" # stylus
        "ghmbeldphafepmbegfdlkpapadhbakde" # proton pass
        "hdpcadigjkbcpnlcpbcohpafiaefanki" # nighttab
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # catppuccin-mocha
      ];
    };
  };
}
