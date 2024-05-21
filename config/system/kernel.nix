{ config, ... }:

{
  imports = [
    ./kernel/default.nix
    ./kernel/latest.nix
    ./kernel/lqx.nix
    ./kernel/xanmod.nix
    ./kernel/zen.nix
    
    # For the adventurous people
    # It's not listed in the list of possible options, 
    # but the ones who want to try it can do so.
    ./kernel/testing.nix
  ];
}
