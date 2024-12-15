{ pkgs, lib, ... }:

{
  imports = [
    ../modules/extras.nix
  ];

  extras.passwordlessSSH.enable = lib.mkDefault true;
  extras.remoteUpdates.enable = lib.mkDefault true;

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

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = lib.mkDefault true;
  services.tailscale.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    home-manager
    gnome3.gnome-tweaks
  ];

  system.stateVersion = lib.mkDefault "24.05"; # Did you read the comment?
}
