{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./gnome.nix
    ./comfort.nix
    ./yubikey.nix
    ./users.nix
    ];

  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "kvm-intel" ];

  time.timeZone = "America/New_York";
  i18n = {
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  hardware.bluetooth.enable = lib.mkForce false;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    rsync openssh git gnupg smartmontools fwupd
    nmap tcpdump dnsutils traceroute pciutils usbutils
    file htop tree hexd pixd rlwrap mkpasswd
    gummi texlive.combined.scheme-full
    signal-desktop quasselClient
    gimp inkscape mpv firefox
    python3 ghc jq dash nodejs racket
    nix-index
    # mathematica jupyter plover.dev qemu pijul
  ] ++ (with python3Packages; [ numpy scipy matplotlib pillow ]);

  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    latinmodern-math lmodern
  ];

}
