{
  pkgs,
  config,
  ...
}: {
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
}
