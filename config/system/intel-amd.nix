{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) gpuType; in
lib.mkIf ("${gpuType}" == "intel-amd") { 
  nixpkgs.config.packageOverrides =
    pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {
      enableHybridCodec = true;
    };
  };

  # OpenGL
  hardware.opengl = {
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      amdvlk
    ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
