# Configuration for "Hilbert".

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./gui.nix
    ./yubikey.nix
    ./users.nix
    ./common.nix
    ./hilbert-secret.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname.
  networking.hostName = "hilbert";

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # High resolution.
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # Intel CPU.
  hardware.cpu.intel.updateMicrocode = true;

  # NVidia graphics.
  services.xserver.videoDrivers = [ "modesetting" "nouveau" ];

  system.stateVersion = "20.09"; # Almost never change.
}
