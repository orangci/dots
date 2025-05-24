{
  pkgs,
  username,
  host,
  ...
}: {
  imports = [../../homes/${username}];

  hmModules = {
    cli = {
      fetch.enable = true;
      shell.program = "fish";
      eza.enable = true;
      fd.enable = true;
      zoxide.enable = true;
      ripgrep.enable = true;
      bat.enable = true;
      fzf.enable = true;
      fun.enable = true;
      compression = {
        enable = true;
        zip = true;
      };

      git = {
        enable = true;
        username = "orangc";
        email = "c@orangc.net";
        github = true;
      };
    };

    programs.starship.enable = true;
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  services.cliphist.enable = false;
  programs.home-manager.enable = true;
}
