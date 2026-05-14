{
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs { doCheck = !prev.stdenv.hostPlatform.isi686; };
    })
  ];

  nix = {
    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://feel-co.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "feel-co.cachix.org-1:nwEFNnwZvtl4KKSH5LDg+/+K7bV0vcs6faMHAJ6xx0w="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

}
