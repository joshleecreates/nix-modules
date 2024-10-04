{ config, lib, ... }:

with lib;
let
  cfg = config.extras;
in
{
  options = {
    extras.mDNS.enable = lib.mkEnableOption "mdns with avahi";
    extras.passwordlessSSH.enable = lib.mkEnableOption "passwordless SSH";
    extras.remoteUpdates = {
      enable = lib.mkEnableOption "remote updates with nixos rebuild";
      username = lib.mkOption {
        type = str;
        description = "the user who will apply remote updates";
      };
      publicKey = lib.mkOption {
        type = str;
        description = "the public ssh key for the user who will apply remote updates";
      };
    };
  };

  config = {
    # Enable mDNS for `hostname.local` addresses
    services.avahi = mkIf cfg.mDNS.enable {
      enable = true;
      avahi.nssmdns = true;
      avahi.publish = {
        enable = true;
        addresses = true;
      };
    };

    # Enable ssh
    services.openssh = mkIf cfg.passwordlessSSH.enable {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };
    programs.ssh.startAgent = mkIf cfg.passwordlessSSH.enable true;

    # Don't ask for sudo passwords
    security.sudo.wheelNeedsPassword = false;
  };
}
