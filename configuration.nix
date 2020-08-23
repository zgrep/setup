{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware.nix
      ./users.nix
      ./gnome.nix
      ./comfort.nix
      ./yubikey.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ exfat-nofuse v4l2loopback ];
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "poincare";

  # Select internationalisation properties.
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # Fancy typing.
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ table table-others ];
  };

  # I use an Intel laptop.
  boot.initrd.kernelModules = [ "i915" ];
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Only thing that this sees is my Samsung SSD.
  services.fwupd.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # No bluetooth.
  hardware.bluetooth.enable = false;

  # Printing.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint hplip ];
  hardware.sane.enable = true;

  # Packages.
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.systemPackages = with pkgs; [
    # Misc.
    pavucontrol beancount fwupd

    # Generally useful.
    rsync openssh git gnupg wget rlwrap pdfgrep jq
    nmap tcpdump dnsutils traceroute whois pciutils usbutils
    file tree hexd pixd mkpasswd unar htop
    (aspellWithDicts (ps: with ps; [ en en-computers en-science ]))
    keepassxc
    wl-clipboard

    # LaTeX.
    gummi texlive.combined.scheme-full

    # Graphical.
    mpv firefox
    signal-desktop quasselClient
    gimp inkscape

    # Programming.
    pypy3
    (python3.withPackages (ps: with ps; [ numpy scipy matplotlib pillow lark-parser pyside2]))
    nix-index patchelf

    # Virtualization.
    virtmanager qemu libguestfs

    # Remote Administration.
    openvpn remmina

    # Specifically Useful
    audacity
    ffmpeg-full
    youtube-dl
    masterpdfeditor
    obs-studio
    calibre
    nasc
    steam-run-native
    rawtherapee
  ];

  # SSH.
  programs.ssh.startAgent = false;
  programs.ssh.extraConfig = ''
    IdentitiesOnly yes
  '';

  # Fonts.
  fonts.enableDefaultFonts = true;

  # Android.
  programs.adb.enable = true;

  # Virtualization.
  virtualisation.libvirtd.enable = true;

  # Firejail.
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      zoom-us = "${lib.getBin pkgs.zoom-us}/bin/zoom-us";
    };
  };

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "20.03"; # Almost never change.
}

