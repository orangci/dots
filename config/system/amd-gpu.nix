{ pkgs, config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) gpuType; in
lib.mkIf ("${gpuType}" == "amd") {
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # OpenGL
  hardware.opengl = {
    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
}
