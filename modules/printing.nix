{ config
, pkgs
, lib
, ...
}: {
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.brgenml1cupswrapper ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    samba.enable = true;
  };
  hardware.sane.enable = true; # for scanners, I think?
}