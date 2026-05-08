# This is shamelessly stolen from https://github.com/llakala/synaptic-standard
# llakala has not placed a license on this code as of 2026-05-08
# this is not the original version and has been modified
{ lib }:

let
  inherit (lib) hasSuffix singleton;
  inherit (builtins)
    concatMap
    isPath
    filter
    readFileType
    ;

  expandIfFolder =
    elem:
    if !isPath elem || readFileType elem != "directory" then
      singleton elem
    else
      lib.filesystem.listFilesRecursive elem;

in
list:
filter
  # Filter out any path that doesn't look like `*.nix`
  (elem: (!isPath elem || hasSuffix ".nix" (toString elem)))
  # Expand any folder to all the files within it.
  (concatMap expandIfFolder list)
