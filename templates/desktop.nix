{ pkgs, lib, ... }:

{
  imports = [
    ../modules/extras.nix
  ];

  extras.passwordlessSSH.enable = true;
  extras.remoteUpdates.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;
  services.tailscale.enable = lib.mkDefault true;
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    home-manager
    gnome3.gnome-tweaks
  ];

  system.stateVersion = lib.mkDefault "24.05"; # Did you read the comment?
}
