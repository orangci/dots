# Thank you to https://github.com/Stef-00012/dots/blob/main/modules/server/ntfy.nix for the original topicsOptions and the ntfy-users script
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    singleton
    ;
  cfg = config.modules.server.ntfy;
  topicsOptions = import ./topicsOptions.nix { inherit lib config; };
in
{
  imports = singleton ./scripts;
  options.modules.server.ntfy = {
    enable = mkEnableOption "Enable ntfy";

    name = mkOption {
      type = types.str;
      default = "Ntfy";
    };

    domain = mkOption {
      type = types.str;
      default = "ntfy.orangc.net";
      description = "The domain for ntfy to be hosted at";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for ntfy to be hosted at";
    };

    users = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            username = mkOption {
              type = types.str;
              description = "Username for the ntfy user";
            };

            role = mkOption {
              type = types.enum [
                "user"
                "admin"
              ];
              description = "Role for the ntfy user (user or admin)";
            };
          };
        }
      );
      default = [ ];
      description = "List of ntfy users with username and role (user or admin)";
    };

    topics = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = topicsOptions.topic;
            users = topicsOptions.users;
            permission = topicsOptions.permission;
          };
        }
      );
      default = [ ];
      description = "List of ntfy topics with username of the user who can access it and with what permission";
    };
  };

  config = mkIf cfg.enable {
    # File format:
    # user1 = password1
    # user2 = password2
    modules.common.sops.secrets.ntfy-users.path = "/var/secrets/ntfy-users";
    # This secret should contain
    # NTFY_ACCESS_TOKEN=abc123
    modules.common.sops.secrets.ntfy-access-token = {
      path = "/var/secrets/ntfy-access-token";
      owner = "ntfy-sh";
    };

    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}";
        auth-default-access = "deny-all";
        listen-http = ":${toString cfg.port}";
        behind-proxy = true;
        attachment-total-size-limit = "3G";
        enable-login = true;
        upstream-base-url = "https://ntfy.sh";
        enable-metrics = false;
        log-level = "info";
        log-level-overrides = [
          "tag=manager -> trace"
          "emails_received -> trace"
          "emails_received_failure -> trace"
          "emails_received_success -> trace"
          "emails_sent -> trace"
          "emails_sent_failure -> trace"
          "emails_sent_success -> trace"
        ];

        # web-push-public-key = "REDACTED";
        # web-push-private-key = "REDACTED";
        # web-push-file = /var/lib/ntfy-sh/webpush.db;
        # web-push-email-address = "c@orangc.net";
      };
    };

    systemd.services.ntfy-users = {
      description = "Run ntfy-users app";
      before = [ "ntfy-sh.service" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        gcc
        vips
        openssl_3
        ntfy-sh
        gawk
        findutils
      ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "run-ntfy-users" ''
          ${builtins.concatStringsSep "\n" (
            map (
              user:
              "yes $(cat /var/secrets/ntfy-users | grep ${user.username} | awk -F'=' '{print $2}' | xargs) | ntfy user -c /etc/ntfy/server.yml add --ignore-exists --role=${user.role} ${user.username}"
            ) cfg.users
          )}

          user_list=$(ntfy user -c /etc/ntfy/server.yml list 2>&1)

          previous_users=(${builtins.concatStringsSep " " (map (user: "${user.username}") cfg.users)})

          is_in_previous_users() {
              local user=$1
              for prev in "''${previous_users[@]}"; do
                  if [[ "$prev" == "$user" ]]; then
                      return 0
                  fi
              done
              return 1
          }

          # Read line by line
          while read -r line; do
              if [[ $line =~ ^user\ ([^[:space:]]+) ]]; then
                  username="''${BASH_REMATCH[1]}"
                  if [[ "$username" == "*" ]]; then
                      continue
                  fi
                  if ! is_in_previous_users "$username"; then
                      ntfy user -c /etc/ntfy/server.yml remove $username
                  fi
              fi
          done <<< "$user_list"

          ntfy access -c /etc/ntfy/server.yml --reset

          ${builtins.concatStringsSep "\n" (
            map (
              topic:
              builtins.concatStringsSep "\n" (
                map (
                  user: "ntfy access -c /etc/ntfy/server.yml ${user} ${topic.name} ${topic.permission}"
                ) topic.users
              )
            ) cfg.topics
          )}
        '';
        Restart = "no";
      };
    };
  };
}
