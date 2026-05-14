{ lib, ... }:
{
  imports = lib.singleton (
    lib.mkAliasOptionModule [ "modules" "security" "sudo-rs" ] [ "security" "sudo-rs" ]
  );
}
