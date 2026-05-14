{ lib, ... }:
{
  options.hmModules.programs.editors.xdg = lib.mkOption {
    type = lib.types.str;
    default = "micro";
    description = "The .desktop filename to use for XDG";
  };
}
