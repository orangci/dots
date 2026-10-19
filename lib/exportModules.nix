# turns every module under a directory into a flake output that works in someone else's flake
{
  lib,
  inputs,
  flakeSettings,
  mkMyLib,
}:
let
  inherit (lib)
    filter
    hasSuffix
    listToAttrs
    nameValuePair
    removePrefix
    removeSuffix
    replaceStrings
    ;

  # modules live at modules.<dir>.<name>, so services/media/immich.nix is "services.media.immich"
  # and a folder's default.nix is named after the folder
  moduleName =
    root: file:
    let
      relative = removePrefix "${toString root}/" (toString file);
      withoutSuffix =
        if hasSuffix "/default.nix" relative then
          removeSuffix "/default.nix" relative
        else
          removeSuffix ".nix" relative;
    in
    replaceStrings [ "/" ] [ "." ] withoutSuffix;

  # my modules expect the specialArgs and lib.my that the flake gives its own hosts. a consumer has
  # neither, so supply them here.
  # the module system only hands over the arguments a function declares, so the wrapper declares
  # what the real module does. the supplied ones are left out of that: asking the module system for
  # an argument nobody provided makes it look in config, which recurses while imports resolve
  supplied = [
    "flakeSettings"
    "inputs"
    "system"
    "host"
    "users"
    "sysadmin"
  ];

  wrap =
    file:
    let
      module = import file;
      declared = if lib.isFunction module then lib.functionArgs module else { };
    in
    if !lib.isFunction module then
      module
    else
      lib.setFunctionArgs
        (
          args:
          let
            full = args // {
              lib = args.lib.extend (_: _: { my = mkMyLib args.lib flakeSettings; });
              inherit flakeSettings inputs;
              system = args.pkgs.stdenv.hostPlatform.system;
              host = args.config.networking.hostName;
              users = { };
              sysadmin = throw "this module needs the flake's `sysadmin` user, which only the flake's own hosts define";
            };
          in
          module (lib.intersectAttrs declared full)
        )
        (
          removeAttrs declared supplied
          // {
            lib = false;
            pkgs = true;
            config = true;
          }
        );

  exportDirectory =
    root:
    let
      files = filter (
        file: hasSuffix ".nix" (toString file) && baseNameOf (toString file) != "example.nix"
      ) (lib.filesystem.listFilesRecursive root);
      individual = listToAttrs (map (file: nameValuePair (moduleName root file) (wrap file)) files);
    in
    individual // { default.imports = builtins.attrValues individual; };
in
{
  nixosModules = exportDirectory ../modules;
  homeModules = exportDirectory ../home;
}
