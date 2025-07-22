{ lib, config }:

{
  topic = lib.mkOption {
    type = lib.types.str;
    description = "Name of the ntfy topic";
  };

  users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = let users = config.modules.server.ntfy.users or []; in lib.map (user: user.username) users;
    description = "Users for the ntfy topic";
  };

  permission = lib.mkOption {
    type = lib.types.enum [
      "read-write"
      "read-only"
      "write-only"
      "deny"
    ];
    description = "Permissions for the topic";
  };
}
