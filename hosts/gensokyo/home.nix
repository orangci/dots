{
  username,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  imports = [ ../../homes/${username} ];

  hmModules = {
    programs.editors.nvf.enable = true;
    dev.python.enable = true;
    cli = {
      fetch.enable = true;
      shell.program = "fish";
      oxidisation.enable = true;
      fun.enable = true;
      disk-usage.enable = true;
      starship.enable = true;
      utilities.enable = true;
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
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
  programs.home-manager.enable = true;
}
