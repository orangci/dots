{ config
, pkgs
, lib
, ...
}: {
  services.blueman.enable = true;
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # settings = {
      #   General = {
      #     # show battery status of bluetooth devices
      #     Experimental = true;
      #   };
      # };
    };
};

  # Allow bluetooth headset buttons to work properly
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
};
}