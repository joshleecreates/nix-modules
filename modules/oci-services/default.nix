{ config, pkgs, modulesPath, lib, system, ... }:
with lib;
let
  cfg = config.oci-services;
in
  options.oci-services = {
    enable = mkEnableOption "oci services";
  };

  imports = [
    ./portainer.nix
    ./monitoring.nix
  ];

  config = mkIf cfg.enable {
    services.nginx.enable = true;

    # todo: allow docker
    # todo: add portainer agent
    virtualisation.docker.enable = false;
    virtualisation.podman.enable = true;
    virtualisation.podman.dockerCompat = true;
    virtualisation.oci-containers.backend = "podman";
  };
}

