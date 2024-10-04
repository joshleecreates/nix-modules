{ config, ... }:
{
  imports = [
    ../profiles/vm.nix
    ../modules/oci-services/default.nix
    ../modules/extras.nix
  ];

  networking.hostName = "home-cloud-example";
  oci-services.enable = true;
  oci-services.monitoring.enable = true;
  oci-services.portainer.enable  = true;
  extras.remoteUpdates = {
    enable = true;
    remoteUser = "homecloud";
    publicKey = "";
  }
  extras.passwordlessSSH.enable = true;
}
