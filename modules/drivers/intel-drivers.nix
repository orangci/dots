{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [ "i915.enable_guc=3" ];
    nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    # OpenGL
    hardware.intel-gpu-tools.enable = true;
    hardware.enableRedistributableFirmware = true;
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
      VDPAU_DRIVER = "va_gl"; # Only if using libvdpau-va-gl
    };
  };
}
