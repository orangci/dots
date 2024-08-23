{
  pkgs,
  username,
  host,
  inputs,
  ...
}: let
  inherit (import ./hosts/${host}/variables.nix) gitUsername gitEmail;
in {
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = [inputs.nixvim.packages.${pkgs.system}.default];
    stateVersion = "24.11";
    file = {
      ".local/share/fonts" = {
        source = ./files/fonts;
        recursive = true;
      };
      ".face.icon".source = ./files/face.png;
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
