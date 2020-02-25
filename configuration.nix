# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gnome.nix
      ./comfort.nix
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Proprietary bullshit.
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  networking.hostName = "illegal-uturn"; # Define your hostname.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Printing.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip ];
  hardware.sane.enable = true;

  # Packages.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    rsync openssh git gnupg wget
    smartmontools fwupd
    nmap tcpdump dnsutils traceroute pciutils usbutils
    file htop tree hexd pixd rlwrap mkpasswd unar
    gummi texlive.combined.scheme-full
    signal-desktop quasselClient
    gimp inkscape mpv firefox
    ghc jq dash nodejs racket
    (python3.withPackages (ps: with ps; [ numpy scipy matplotlib pillow ]))
    nix-index patchelf
    musescore
    plover.dev
    radare2-cutter hopper
    virtmanager qemu libguestfs
    openvpn
    sublime3
  ];

  programs.ssh.startAgent = false;

  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    latinmodern-math lmodern
  ];

  programs.adb.enable = true;

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "19.09"; # Almost never change.
}

