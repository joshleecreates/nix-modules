{ modulesPath, lib, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  #Provide a default hostname
  networking.hostName = lib.mkDefault "vm";

  # Enable QEMU Guest for Proxmox
  services.qemuGuest.enable = lib.mkDefault true;

  # Use the boot drive for grub
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.devices = [ "nodev" ];

  boot.growPartition = true;

  # Default filesystem
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };
}
