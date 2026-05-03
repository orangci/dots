{
  flakeSettings,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  imports = [ ../../homes/${flakeSettings.username} ];

  hmModules = {
    programs.editors.nvf.enable = true;
    programs.editors.micro.enable = true;
    dev = {
      python = {
        enable = true;
        version = "python314";
      };
      nix.enable = true;
      direnv.enable = true;
    };
    cli = {
      fetch.enable = true;
      shell.program = "fish";
      oxidisation.enable = true;
      fun.enable = true;
      disk-usage.enable = true;
      starship.enable = true;
      utilities.enable = true;
      media.enable = true;
      compression = {
        enable = true;
        zip = true;
      };
      git = {
        enable = true;
        inherit (flakeSettings) username;
        email = "c@${flakeSettings.domains.email}";
        github = true;
      };
    };
  };

  home = {
    username = "${flakeSettings.username}";
    homeDirectory = "/home/${flakeSettings.username}";
    stateVersion = "25.05";
  };

  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
  programs.home-manager.enable = true;
}
