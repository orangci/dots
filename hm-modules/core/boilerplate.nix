{
  pkgs,
  username,
  host,
  inputs,
  ...
}: let
  gitUsername = "orxngc";
  gitEmail = "orangc@proton.me";
in {
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = [inputs.nixvim.packages.${pkgs.system}.default pkgs.hyprpanel];
    stateVersion = "24.11";
    file = {
      ".local/share/fonts" = {
        source = ../../files/fonts;
        recursive = true;
      };
      ".face.icon".source = ../../files/face.png;
    };
  };

  imports = [
    ../.
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  services = {
    cliphist.enable = true;
  };
  programs = {
    eza.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gh.enable = true;
    home-manager.enable = true;
    kitty = {
      enable = true;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        leonardssh.vscord # discord RPC
        kamadorueda.alejandra # nix formatter
        bradgashler.htmltagwrap # html tag wrapping
        ecmel.vscode-html-css # html & css formatting
        ritwickdey.liveserver # live server
        catppuccin.catppuccin-vsc-icons # catppuccin icons
        catppuccin.catppuccin-vsc # catppuccin
      ];
    };
    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock
        "clngdbkpkpeebahjckkjfobafhncgmne" # stylus
        "ghmbeldphafepmbegfdlkpapadhbakde" # proton pass
        "hdpcadigjkbcpnlcpbcohpafiaefanki" # nighttab
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # catppuccin-mocha
      ];
    };
    mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };
    git = {
      enable = true;
      userName = "${gitUsername}";
      userEmail = "${gitEmail}";
    };
  };
}
