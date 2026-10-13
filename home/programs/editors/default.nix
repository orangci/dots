{ lib, ... }:
{
  options.hmModules.programs.editors.xdg = lib.mkOption {
    type = lib.types.str;
    default = "micro";
    example = "codium";
    description = "The `.desktop` file of the default editor, used for XDG mime associations. Editor modules set this themselves.";
  };
}
