{
  lib,
  sysadmin,
  ...
}:
{
  # applies to every host. anything only a machine with a screen needs goes in
  # modules/desktop/common.nix instead
  time.hardwareClockInLocalTime = true;
  users.mutableUsers = true;
  programs = {
    nh = {
      enable = true;
      flake = "/home/${sysadmin.username}/dots"; # sets NH_FLAKE
    };
    fuse.userAllowOther = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  security.polkit.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
    extraConfig = ''
      Match Address 127.0.0.0/8,::1,192.168.0.0/16,100.64.0.0/10,fd7a:115c:a1e0::/48
        PasswordAuthentication yes
    '';
  };
  security.pam.services.sshd.unixAuth = lib.mkForce true;

  powerManagement.cpuFreqGovernor = "performance";
}
