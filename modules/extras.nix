{ config, lib, ... }:

with lib;
let
  cfg = config.extras;
in
{
  options = {
    extras.mDNS.enable = 
      lib.mkEnableOption "mdns with avahi";
    extras.passwordlessSSH.enable = 
      lib.mkEnableOption "passwordless SSH";
    extras.remoteUpdates.enable = 
      lib.mkEnableOption "remote updates with nixos rebuild";
    };
  };

  config = {
    # Enable mDNS for `hostname.local` addresses
    services.avahi = mkIf cfg.mDNS.enable {
      enable = true;
      nssmdns = true;
      publish = {
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
    security.sudo.wheelNeedsPassword = mkIf cfg.passwordlessSSH.enable false;

    # Allow remote updates with flakes and non-root users
    nix.settings.trusted-users = mkIf cfg.remoteUpdates.enable [ "root" "@wheel" ];
    nix.settings.experimental-features = mkIf cfg.remoteUpdates.enable [ "nix-command" "flakes" ];
  };
}
