{ config, lib, ... }:

with lib;
let
  cfg = config.oci-services.portainer;
in
{
  options.oci-services.portainer = {
    enable = lib.mkEnableOption "portainer";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      portainer = {
        image = "portainer/portainer-ce";
        ports = [
          "8000:8000"
          "9443:9443"
        ];
        volumes = [
          "appdata:/data"
          # todo: allow docker
          "/var/run/podman/podman.sock:/var/run/docker.sock:Z"
        ];
        extraOptions = [
          "--privileged"
        ];
      };  
    };
  };
}
