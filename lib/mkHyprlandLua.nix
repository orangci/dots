{ lib }:
let
  inherit (lib) concatStringsSep splitString trim;
  inline = lib.generators.mkLuaInline;
  json = builtins.toJSON;

  modifiers = {
    "" = "";
    SUPER = "SUPER";
    ALT = "ALT";
    SHIFT = "SHIFT";
    CONTROL = "CTRL";
    SUPERALT = "SUPER + ALT";
    SUPERSHIFT = "SUPER + SHIFT";
    SUPERCONTROL = "SUPER + CTRL";
    "SUPER SHIFT" = "SUPER + SHIFT";
  };

  key =
    mods: name:
    let
      normalisedMods = lib.toUpper (lib.replaceStrings [ "+" " " ] [ "" "" ] mods);
      prefix =
        modifiers.${normalisedMods} or (throw "Unsupported Hyprland modifier combination: ${mods}");
    in
    if prefix == "" then name else "${prefix} + ${name}";

  action =
    dispatcher: argument: mouse:
    inline (
      if dispatcher == "exec" then
        "hl.dsp.exec_cmd(${json argument})"
      else if dispatcher == "workspace" then
        "hl.dsp.focus({ workspace = ${json argument} })"
      else if dispatcher == "movetoworkspace" then
        "hl.dsp.window.move({ workspace = ${json argument} })"
      else if dispatcher == "togglespecialworkspace" then
        "hl.dsp.workspace.toggle_special(${json argument})"
      else if dispatcher == "killactive" then
        "hl.dsp.window.close()"
      else if dispatcher == "fullscreen" then
        "hl.dsp.window.fullscreen()"
      else if dispatcher == "movefocus" then
        "hl.dsp.focus({ direction = ${json argument} })"
      else if dispatcher == "movewindow" && mouse then
        "hl.dsp.window.drag()"
      else if dispatcher == "movewindow" then
        "hl.dsp.window.move({ direction = ${json argument} })"
      else if dispatcher == "resizewindow" then
        "hl.dsp.window.resize()"
      else if dispatcher == "cyclenext" then
        "hl.dsp.window.cycle_next()"
      else if dispatcher == "bringactivetotop" then
        "hl.dsp.window.alter_zorder({ mode = \"top\" })"
      else if dispatcher == "togglefloating" then
        "hl.dsp.window.float({ action = \"toggle\" })"
      else
        throw "Unsupported legacy Hyprland dispatcher: ${dispatcher}"
    );

  bind =
    {
      description ? null,
      flags ? { },
    }:
    spec:
    let
      fields = map trim (splitString "," spec);
      descriptionOffset = if description == null then 0 else 1;
      mods = builtins.elemAt fields 0;
      name = builtins.elemAt fields 1;
      resolvedDescription = if description == null then null else builtins.elemAt fields 2;
      dispatcher = builtins.elemAt fields (2 + descriptionOffset);
      argument = concatStringsSep "," (lib.drop (3 + descriptionOffset) fields);
      resolvedFlags = flags;
    in
    {
      _args = [
        (key mods name)
        (action dispatcher argument (flags.mouse or false))
        (
          if resolvedDescription == null then
            resolvedFlags
          else
            resolvedFlags // { description = resolvedDescription; }
        )
      ];
    };

  rule =
    spec:
    let
      fields = map trim (splitString "," spec);
      matchField = builtins.elemAt fields 0;
      matchParts = splitString " " (lib.removePrefix "match:" matchField);
      matchName = builtins.elemAt matchParts 0;
      matchValue = concatStringsSep " " (lib.drop 1 matchParts);
      effectParts = splitString " " (builtins.elemAt fields 1);
      effectName = builtins.elemAt effectParts 0;
      rawEffectValue = concatStringsSep " " (lib.drop 1 effectParts);
      effectValue =
        if rawEffectValue == "on" then
          true
        else if rawEffectValue == "off" then
          false
        else if builtins.match "[0-9]+(\\.[0-9]+)?" rawEffectValue != null then
          builtins.fromJSON rawEffectValue
        else
          rawEffectValue;
    in
    {
      match = {
        ${matchName} = matchValue;
      };
      ${effectName} = effectValue;
    };
in
{
  bindd = map (bind {
    description = true;
  });
  bindde = map (bind {
    description = true;
    flags = {
      repeating = true;
    };
  });
  binddm = map (bind {
    description = true;
    flags = {
      mouse = true;
    };
  });
  bindld = map (bind {
    description = true;
    flags = {
      locked = true;
    };
  });
  onStart = command: {
    _args = [
      "hyprland.start"
      (inline "function()\n  hl.exec_cmd(${json command})\nend")
    ];
  };
  env =
    entry:
    let
      fields = splitString "," entry;
    in
    {
      _args = [
        (builtins.elemAt fields 0)
        (concatStringsSep "," (lib.drop 1 fields))
      ];
    };
  layerRule = rule;
  windowRule = rule;
}
