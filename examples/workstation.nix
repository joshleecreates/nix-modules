{ config, pkgs, ... }:
{
  imports = [
    # Import a VM 'hardware' profile
    ../profiles/vm.nix
    # Import a basic template
    ../templates/workstation.nix
  ];

  # Set a unique host name
  networking.hostName = "example";

  # Modify this user as needed
  users.users.admin = {
    isNormalUser = true;
    description = "Linux Admin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAg/E2UkXORp58O3zxp0dQird+UcvdJkCpKbZj5+ccmh josh@joshuamlee.com"
    ];
  };

  # Enable zsh (if preferred)
  programs.zsh.enable = true;
  users.users.admin.shell = pkgs.zsh;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
