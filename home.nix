{
  pkgs,
  username,
  host,
  ...
}: let
  inherit (import ./hosts/${host}/variables.nix) gitUsername gitEmail;
in {
  home = {
    # Home Manager Settings
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
    file = {
      ".local/share/fonts" = {
        source = ./files/fonts;
        recursive = true;
      };
      ".face.icon".source = ./files/face.png;
      ".config/Vencord/themes/orangetweaks.css".source = ./files/vencordthemes/orangetweaks.css;
      ".config/Vencord/themes/catppuccin.css".source = ./files/vencordthemes/catppuccin.css;
    };
  };

  imports = [
    ./hm-modules
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  services.cliphist.enable = true;
  programs = {
    eza.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gh.enable = true;
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "${gitUsername}";
      userEmail = "${gitEmail}";
    };
  };
}
