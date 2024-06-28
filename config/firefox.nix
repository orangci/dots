{
  config,
  host,
  username,
  ...
}:
{
  programs.firefox = {
    enable = true;

    profiles.${username} = {
      userChrome = ''
        /* some css */
      '';
    };
  };
}
