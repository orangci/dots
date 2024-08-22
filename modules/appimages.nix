{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    appimages.enable =
      lib.mkEnableOption "enables appimages";
  };
  config = lib.mkIf config.appimages.enable {
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    environment.systemPackages = [pkgs.appimagerun];
  };
}
