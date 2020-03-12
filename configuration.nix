{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./gnome.nix
      ./comfort.nix
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # All the filesystems, since I don't know where else to add them.
  boot.supportedFilesystems = [ "ntfs" "exfat" "ext4" "vfat" "ext3" "ext2" "zfs" ];

  # For ZFS.
  networking.hostId = "b05abbf2";

  # Proprietary bullshit.
  hardware.cpu.intel.updateMicrocode = true;
  services.fwupd.enable = true;

  networking.hostName = "asbestos"; # Define your hostname.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # No bluetooth.
  hardware.bluetooth.enable = false;

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
    remmina
    gsmartcontrol
    (aspellWithDicts (ps: with ps; [ en en-computers en-science ]))
  ];

  # SSH.
  programs.ssh.startAgent = false;
  programs.ssh.extraConfig = ''
    IdentitiesOnly yes
  '';

  # Fonts!
  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    latinmodern-math lmodern
  ];

  # Android.
  programs.adb.enable = true;

  # Virtualization.
  virtualisation.libvirtd.enable = true;

  system.stateVersion = "19.09"; # Almost never change.
}

