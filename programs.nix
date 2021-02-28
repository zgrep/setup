# Programs and utilities that I like having installed.

{ pkgs, config, ... }:

{
  imports = [
    ./syncthing.nix
    ./plover.nix
  ];

  environment.systemPackages = with pkgs; [
    # Useful utilities.
    openssh git gnupg rsync wget
    rlwrap pdfgrep jq
    nmap tcpdump dnsutils traceroute whois pciutils usbutils
    file tree hexd pixd mkpasswd unar htop
    (aspellWithDicts (ps: with ps; [ en en-computers en-science ]))
    wl-clipboard     # Terminal ←→ clipboard.
    ffmpeg-full      # Video and audio munging.
    v4l-utils        # Video4Linux control.
    exiftool         # Image and video metadata reader.
    u3-tool          # U3 flashdrives pretend to be CDs. This lets you write to the CD part.
    youtube-dl       # Download YouTube videos.
    bsdgames         # rot13, fortune, etc.
    magic-wormhole   # Share files safely and securely!
    beancount        # Plain-text finances.

    # Graphical.
    keepassxc        # Password manager.
    mpv              # Video player.
    firefox          # Web browser.
    signal-desktop   # Secure communication.
    quasselClient    # IRC.
    gimp inkscape    # Raster and vector image editing.
    gImageReader     # OCR, sometimes useful.
    masterpdfeditor  # A (closed-source) PDF editor.
    wireshark        # Packet inspector (network, usb, etc).
    font-manager     # Look at fonts, lets you search through them for characters.
    pavucontrol      # A graphical PulseAudio controller.

    # CAD.
    openscad         # Code-generated CAD, the only CAD tool I know how to use.
    solvespace       # The tool I failed to use once.
    kicad            # Circuits! In case I ever get around to using it.

    # App launchers.
    steam-run-native # I've used this for Fez.
    appimage-run     # I've used this for Plover.

    # LaTeX
    gummi texlive.combined.scheme-full

    # Notes and journal.
    (zim.overrideAttrs (attrs: {
      propagatedBuildInputs = attrs.propagatedBuildInputs ++ [
        gtksourceview
        python3Packages.xdot
        graphviz ditaa seqdiag
        gtkspell3
        texlive.combined.scheme-full
      ];
    }))
    # TODO: Maybe look into emacs and org-mode.

    # Programming
    pypy3
    (python3.withPackages (ps: with ps; [ numpy scipy matplotlib pillow lark-parser pyside2 z3 ]))
    racket
    patchelf
    nix-index

    # Virtualization.
    virtmanager qemu # libguestfs, broken?

    # Remote administration.
    openvpn remmina

    # Extra.
    #zoom-us          # TODO: I should run this in a container.
    #gnumeric         # Spreadsheets.
    #abiword          # Word documents.
    #calibre          # Manages ebooks, converts formats, etc.
    #obs-studio       # Recording my screen/audio.
    #audacity         # Recording audio, editing audio.
    #rawtherapee      # Convert RAW camera files. See also: darktable.
    #nasc             # Unit conversions.
    #pulseeffects     # PulseAudio effects.
  ];

  # Virtualization, again.
  virtualisation.libvirtd.enable = true;

  # SSH configuration.
  programs.ssh.startAgent = false;
  programs.ssh.extraConfig = ''
    IdentitiesOnly yes
  '';

  # System profiler.
  services.sysprof.enable = true;

  # Android.
  programs.adb.enable = true;

  # Firmware updater service.
  services.fwupd.enable = true;

  # Printing.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };
  hardware.sane.enable = true;

  # Nix with Flakes.
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nixpkgs.config.allowUnfree = true;

  # Filesystem support.
  boot.extraModulePackages = with config.boot.kernelPackages; [ exfat-nofuse v4l2loopback ];
  boot.supportedFilesystems = [ "ntfs" ];
}
