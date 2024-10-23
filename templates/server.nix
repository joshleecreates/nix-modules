{ pkgs, lib, ... }:
{
  imports = [
    ../modules/oci-services/default.nix
    ../modules/extras.nix
  ];

  networking.hostName = "server";

  # Enable podman & portainer
  oci-services.enable = true;
  oci-services.portainer.enable  = true;

  # Allow remote updates with nixos-rebuild --target-host
  extras.remoteUpdates.enable = true;
  # Enable SSH, without password access
  extras.passwordlessSSH.enable = true;
  environment.systemPackages = with pkgs; [
    git
    python3
    dnsutils
  ];
}
