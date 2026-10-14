{ inputs, ... }:
{
  # the list lives in the webpage repo (src/content/redirects.toml), so its build can check
  # that links to these work and that no short link shadows a real page
  config.modules.services.webpages.main.redirects = inputs.webpagc.lib.redirects;
}
