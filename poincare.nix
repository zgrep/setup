# Configuration for "Poincare".

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./gui.nix
    ./yubikey.nix
    ./users.nix
    ./common.nix
    ./poincare-secret.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname.
  networking.hostName = "poincare";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Console font.
  console.font = "Lat2-Terminus16";

  # No bluetooth.
  hardware.bluetooth.enable = false;

  # I use an Intel laptop.
  boot.initrd.kernelModules = [ "i915" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  system.stateVersion = "20.09"; # Almost never change.
}
