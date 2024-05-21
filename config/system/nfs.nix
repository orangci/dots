{ config, lib, host, ... }:

let inherit (import ../../hosts/${host}/options.nix) nfs nfsMountPoint nfsDevice; in
lib.mkIf (nfs == true) {
  fileSystems."${nfsMountPoint}" = {
    device = "${nfsDevice}";
    fsType = "nfs";
  };
  services = {
    rpcbind.enable = true;
    nfs.server.enable = true;
  };
}
