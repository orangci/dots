{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    concatStringsSep
    mapAttrsToList
    ;
  cfg = config.hmModules.desktop.xcompose;

  # the compose key is Insert, see kb_options in the compositor configs
  defaults = {
    "<Multi_key> <s> <h> <r> <u> <g>" = "¯\\\\_(ツ)_/¯";
    "<Multi_key> <t> <f> <l> <i> <p>" = "(╯°□°)╯︵ ┻━┻";
    "<Multi_key> <s> <a> <l> <a> <m>" = "السلام عليكم ورحمة الله وبركاته";
    "<Multi_key> <w> <s> <a> <l> <a> <m>" = "وعليكم السلام ورحمة الله وبركاته";
    "<Multi_key> <i> <n> <s> <h> <a> <l> <l> <a> <h>" = "إن شاء الله";
    "<Multi_key> <m> <a> <s> <h> <a> <l> <l> <a> <h>" = "ما شاء الله";
    "<Multi_key> <a> <l> <h> <a> <m> <d>" = "الحمد لله";
  };

  mkLine = keys: result: "${keys} : \"${result}\"";
in
{
  options.hmModules.desktop.xcompose = {
    enable = mkEnableOption "a personal XCompose file";
    sequences = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        "<Multi_key> <r> <e> <i> <m> <u>" = "🐇";
      };
      description = "Extra compose sequences, as key sequence to resulting text. They are merged with the built-in ones.";
    };
  };

  config = mkIf cfg.enable {
    # %L pulls in the compose table of the current locale, so the defaults survive
    home.file.".XCompose".text = ''
      include "%L"

      ${concatStringsSep "\n" (mapAttrsToList mkLine (defaults // cfg.sequences))}
    '';
  };
}
