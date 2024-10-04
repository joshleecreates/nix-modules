{ config, pkgs, modulesPath, lib, system, ... }:

{
  cfg = config.oci-services;
  options.oci-services = {
    enable = mkEnableOption "oci services";
  };

  imports = [
    ./portainer.nix
    ./monitoring.nix
  ];

  config = mkIf cfg.enable {
    services.nginx.enable = true;

    # enable podman
    # todo: allow docker
    virtualisation.docker.enable = false;
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;
    virtualisation.oci-containers.backend = "podman";
  };
}

