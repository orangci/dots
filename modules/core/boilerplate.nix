{
  config,
  pkgs,
  users,
  ...
}:
{
  time.hardwareClockInLocalTime = true;
  users.mutableUsers = true;
  environment.sessionVariables = {
    NH_FLAKE = "/home/${users.sysadmin.username}/dots";
    FLAKE = "/home/${users.sysadmin.username}/dots";
  };

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      })
    '';
  };

  services = {
    xserver = {
      enable = false;
      xkb.layout = "us";
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "yes";
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
    libinput.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  powerManagement = {
    cpuFreqGovernor = "performance";
    powertop.enable = true;
  };
}
