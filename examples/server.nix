{ config, pkgs, ... }:
{
  imports = [
    ../profiles/vm.nix
    ../modules/oci-services/default.nix
    ../modules/extras.nix
  ];

  networking.hostName = "home-cloud-example";

  # Enable podman & portainer
  oci-services.enable = true;
  oci-services.portainer.enable  = true;
  # Enable monitoring stack (Prometheus + Grafana)
  oci-services.monitoring.enable = true;

  # Allow remote updates with nixos-rebuild --target-host
  extras.remoteUpdates.enable = true;
  # Enable SSH, without password access
  extras.passwordlessSSH.enable = true;

  # Modify this user as needed
  users.users.admin = {
    isNormalUser = true;
    description = "Linux Admin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAg/E2UkXORp58O3zxp0dQird+UcvdJkCpKbZj5+ccmh josh@joshuamlee.com"
    ];
  };
  programs.zsh.enable = true;
}
