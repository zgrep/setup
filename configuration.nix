{ config, pkgs, lib, ... }:

let
  mkForce = lib.mkForce;
in {

  imports =
    [
      ./hardware-configuration.nix
      ./private.nix # User passwords, extraHosts, etc. Mainly just what I didn't want public.
    ];

  # Maybe this is important. Maybe not.
  hardware.cpu.intel.updateMicrocode = true;

  # EFI boot with encrypted ZFS.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;

  # Virtualization.
  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.virtualbox.host.enable = true;

  # ZFS services.
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;

  # Timezone.
  time.timeZone = "America/New_York";

  # Console comfort.
  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  # Shell comfort.
  environment.etc."inputrc".text = ''
    set editing-mode vi
    $if mode=vi
    set keymap vi-command
    Control-l: clear-screen
    set keymap vi-insert
    Control-l: clear-screen 
    $endif
  '';
  environment.shellAliases = {
    ls = "ls -a --color";  # Colorful, unhidden ls!
    time = "command time"; # Grr.
    e = "$EDITOR";         # Editor alias.
  };
  programs.bash = {
    enableCompletion = true;
    promptInit = ''
      # If return code isn't 0, a nice red color and show it to me, please.
      # Then give me user@host. Then my current directory.
      # And finally, the history number of the command, and the $ or # symbol.
      export PS1='$(s=$?; [ $s == 0 ] || echo "\[\033[0;31m\]$s ")\[\033[0;34m\]\u@\H \[\033[0;32m\]\w\n\[\033[0;34m\]\!\[\033[0;00m\] \$ '

      # Have as many dots as our history number, and then some more.
      # Makes it look nice.
      export PS2='$(expr \! - 1 | tr '1234567890' '.').. '
    '';
  };
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less";
  };

  # GUI comfort.
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "dvorak,phonetic_dvorak";
    xkbOptions = "compose:ralt,caps:escape";

    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome3 = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.touchpad]
        natural-scroll=false
        click-method='areas'
  
        [org.gnome.desktop.interface]
        clock-show-date=true
  
        [org.gnome.desktop.privacy]
        recent-files-max-age=7
        old-files-age=uint32 7
        remove-old-trash-files=true
        report-technical-problems=false
  
        [org.gnome.settings-daemon.plugins.color]
        night-light-enabled=true
  
        [org.gnome.desktop.search-providers]
        sort-order=['org.gnome.Contacts.desktop', 'org.gnome.Documents.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']
        disabled=['org.gnome.clocks.desktop']
        disable-external=false
        enabled=['org.gnome.Characters.desktop']
 
        [org.gnome.desktop.wm.preferences]
        focus-mode='sloppy'

        [org.gnome.nautilus.preferences]
        search-view='list-view'
        default-folder-viewer='list-view'

        [org.gnome.desktop.interface]
        clock-show-seconds=true
  
        [org.gnome.desktop.wm.keybindings]
        move-to-workspace-1=['<Super><Shift>1']
        move-to-workspace-2=['<Super><Shift>2']
        move-to-workspace-3=['<Super><Shift>3']
        move-to-workspace-4=['<Super><Shift>4']
        move-to-workspace-5=['<Super><Shift>5']
        move-to-workspace-6=['<Super><Shift>6']
        move-to-workspace-7=['<Super><Shift>7']
        move-to-workspace-8=['<Super><Shift>8']
        move-to-workspace-9=['<Super><Shift>9']
        move-to-workspace-10=['<Super><Shift>0']
        switch-to-workspace-1=['<Super>1']
        switch-to-workspace-2=['<Super>2']
        switch-to-workspace-3=['<Super>3']
        switch-to-workspace-4=['<Super>4']
        switch-to-workspace-5=['<Super>5']
        switch-to-workspace-6=['<Super>6']
        switch-to-workspace-7=['<Super>7']
        switch-to-workspace-8=['<Super>8']
        switch-to-workspace-9=['<Super>9']
        switch-to-workspace-10=['<Super>0']
      '';
    };
  };
  environment.gnome3.excludePackages = pkgs.gnome3.optionalPackages;
  services.geoclue2.enable = mkForce false;
  services.dleyna-renderer.enable = mkForce false;
  services.dleyna-server.enable = mkForce false;
  services.gnome3.at-spi2-core.enable = mkForce false;
  services.gnome3.evolution-data-server.enable = mkForce false;
  services.gnome3.gnome-documents.enable = mkForce false;
  services.gnome3.gnome-online-accounts.enable = mkForce false;
  services.gnome3.gnome-user-share.enable = mkForce false;
  services.gnome3.seahorse.enable = mkForce false;
  services.telepathy.enable = mkForce false;

  # Bluetooth.
  hardware.bluetooth.enable = mkForce false;

  # Printing.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint gutenprintBin ];

  # My users.
  security.sudo.enable = true;
  users.mutableUsers = false;
  users.users.zgrep = {
    isNormalUser = true;
    home = "/home/zgrep";
    extraGroups = [ "wheel" "audio" "networkmanager" "vboxusers" "dialout" ];
  };

  # Packages.
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.systemPackages = (with pkgs; [
    rsync nmap openssh git neovim gnupg smartmontools qemu
    file htop tree hexd pixd xsel maim xdotool rlwrap
    zeal mpv firefox gimp darktable mypaint mathematica
    gummi texlive.combined.scheme-full
    signal-desktop quasselClient
    python3 ghc jq dash nodejs
    virtualbox arduino
    nix-index
  ]) ++ (with pkgs.gnome3; [
    gnome-terminal gnome-disk-utility
    gnome-logs gnome-system-log
    gnome-power-manager simple-scan
    nautilus file-roller
    eog evince
    baobab gnome-system-monitor gnome-session
    gnome-font-viewer gnome-characters gnome-screenshot
    gnome-clocks gnome-weather
  ]);

  # Package comfort.
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    neovim = neovim.override {
      configure = {
        customRC = ''
          " Set relative/normal numbering.
          set number
          set relativenumber
          
          " Clipboard
          set clipboard=unnamed
          
          " Make line numbers colorless if they're not the line I'm on.
          highlight LineNr ctermfg=none
          highlight CursorLineNr ctermfg=blue
          
          " Syntax coloring on.
          syntax on
          
          " Spaces by default.
          set expandtab tabstop=4 shiftwidth=4 softtabstop=4
          
          " Indentation. It's eough for most things.
          filetype plugin indent on
          
          " Show certain hidden characters.
          set list
          set listchars=tab:>-,nbsp:_,conceal:*
          
          " Wrap text onto next line nicely.
          set linebreak
        '';
      };
    };
  };

}
