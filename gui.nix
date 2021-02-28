# Mostly extracted from nixos/modules/services/x11/desktop-managers/gnome3.nix
# with things that I dislike changed, and with some personal tweaks.

{ pkgs, config, ... }:

let
  background = builtins.fetchurl {
    url = "https://ahti.space/~zgrep/photos/ripples.jpg";
    sha256 = "1ir1wfz98lc5pfq2vg607ysl5dk77hwm4j3ixm1knbsxf061iibr";
  };
in {
  # Keyboard layout, display manager, and Gnome session.
  imports = [
    ./gnome3.nix
  ];

  console.useXkbConfig = true;

  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "dvorak";
    xkbOptions = "caps:escape,compose:prsc";

    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;

    desktopManager.xterm.enable = false;
    desktopManager.gnome3.extraGSettingsOverrides = ''
      [org.gnome.desktop.input-sources]
      mru-sources=[('xkb', 'us+dvorak'), ('ibus', 'table:latex'), ('xkb', 'ru+phonetic_dvorak'), ('xkb', 'us')]
      sources=[('xkb', 'us+dvorak'), ('xkb', 'ru+phonetic_dvorak'), ('ibus', 'table:latex'), ('xkb', 'us')]
      xkb-options=['caps:escape', 'lv3:ralt_switch', 'compose:prsc']

      [org.gnome.desktop.media-handling]
      automount=false
      automount-open=false

      [org.gnome.desktop.media-handling]
      autorun-never=true
      autorun-x-content-ignore=@as []
      autorun-x-content-open-folder=@as []
      autorun-x-content-start-app=@as []

      [org.gnome.desktop.peripherals.touchpad]
      natural-scroll=false
      click-method='areas'

      [org.gnome.desktop.privacy]
      recent-files-max-age=7
      old-files-age=uint32 7
      remove-old-trash-files=true
      report-technical-problems=false
      send-software-usage-stats=false
      disable-camera=true
      disable-microphone=true
      hide-identity=true

      [org.gnome.desktop.search-providers]
      sort-order=['org.gnome.Contacts.desktop', 'org.gnome.Documents.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Characters.desktop', 'org.gnome.clocks.desktop']
      disabled=['org.gnome.clocks.desktop']
      disable-external=false
      enabled=['org.gnome.Characters.desktop']

      [org.gnome.shell.app-switcher]
      current-workspace-only=true

      [org.gnome.desktop.screensaver]
      color-shading-type='solid'
      picture-options='zoom'
      picture-uri='file://${background}'
      primary-color='#000000000000'
      secondary-color='#000000000000'

      [org.gnome.desktop.background]
      color-shading-type='solid'
      picture-options='zoom'
      picture-uri='file://${background}'
      primary-color='#000000000000'
      secondary-color='#000000000000'

      [org.gnome.shell]
      enabled-extensions=['drive-menu@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'caffeine@patapon.info', 'nohotcorner@azuri.free.fr', 'native-window-placement@gnome-shell-extensions.gcampax.github.com', 'wsmatrix@martin.zurowietz.de', 'GPaste@gnome-shell-extensions.gnome.org']
      remember-mount-password=false

      [org.gnome.shell.extensions.caffeine]
      enable-fullscreen=false
      inhibit-apps=@as []
      show-notifications=false
      user-enabled=false

      [org.gnome.nautilus.preferences]
      search-view='list-view'
      default-folder-viewer='list-view'
      show-create-link=true
      search-filter-time-type='last_modified'

      [org.gnome.nautilus.list-view]
      default-column-order=['name', 'size', 'detailed_type', 'type', 'owner', 'group', 'permissions', 'where', 'date_modified', 'date_modified_with_time', 'date_accessed', 'recency', 'starred']
      default-visible-columns=['name', 'size', 'detailed_type', 'date_modified_with_time', 'date_accessed', 'owner', 'group', 'permissions']
      default-zoom-level='small'

      [org.gnome.nautilus.compression]
      default-compression-format='zip'

      [org.gnome.desktop.interface]
      enable-hot-corners=false
      clock-show-date=true
      clock-show-seconds=true
      clock-show-weekday=true
      gtk-enable-primary-paste=false
      show-battery-percentage=true
      monospace-font-name='Fira Mono 11'
      document-font-name='Fira Sans 11'
      font-name='Fira Sans Light 11'
      gtk-im-module='gtk-im-context-simple'
      gtk-theme='Adementary'
      icon-theme='Adwaita'
      gtk-im-module='ibus'
      enable-animations=true

      [org.gnome.shell.overrides]
      workspaces-only-on-primary=true
      dynamic-workspaces=false

      [org.gnome.desktop.wm.preferences]
      titlebar-font='Fira Sans Bold 11'
      num-workspaces=10

      [org.gnome.mutter]
      attach-modal-dialogs=true
      dynamic-workspaces=false
      edge-tiling=true
      workspaces-only-on-primary=true

      [org.gnome.desktop.wm.keybindings]
      move-to-workspace-1=['<Super><Shift>1']
      move-to-workspace-2=['<Super><Shift>2']
      move-to-workspace-3=['<Super><Shift>3']
      move-to-workspace-4=['<Super><Shift>4']
      move-to-workspace-5=['<Super><Shift>5']
      move-to-workspace-6=['<Super><Shift>apostrophe']
      move-to-workspace-7=['<Super><Shift>comma']
      move-to-workspace-8=['<Super><Shift>period']
      move-to-workspace-9=['<Super><Shift>p']
      move-to-workspace-10=['<Super><Shift>y']
      switch-to-workspace-1=['<Super>1']
      switch-to-workspace-2=['<Super>2']
      switch-to-workspace-3=['<Super>3']
      switch-to-workspace-4=['<Super>4']
      switch-to-workspace-5=['<Super>5']
      switch-to-workspace-6=['<Super>apostrophe']
      switch-to-workspace-7=['<Super>comma']
      switch-to-workspace-8=['<Super>period']
      switch-to-workspace-9=['<Super>p']
      switch-to-workspace-10=['<Super>y']

      [org.gnome.shell.keybindings]
      switch-to-application-1=[]
      switch-to-application-2=[]
      switch-to-application-3=[]
      switch-to-application-4=[]
      switch-to-application-5=[]
      switch-to-application-6=[]
      switch-to-application-7=[]
      switch-to-application-8=[]
      switch-to-application-9=[]

      [org.gnome.mutter.keybindings]
      switch-monitor=@as []

      [org.gnome.shell.extensions.wsmatrix]
      multi-monitor=false
      num-columns=5
      num-rows=2
      popup-timeout=600
      show-overview-grid=true
      show-thumbnails=false
      show-workspace-names=false
      wraparound-mode='none'

      [org.gnome.settings-daemon.plugins.xsettings]
      antialiasing='rgba'
      hinting='none'

      [org.gnome.settings-daemon.plugins.media-keys]
      custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

      [org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0]
      binding='F4'
      command='amixer set Capture toggle'
      name='Toggle Microphone'
    '';
  };


  # Fonts.
  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    fira
    open-sans
    lmodern
    noto-fonts
    merriweather
    merriweather-sans
    alegreya
    alegreya-sans
    source-code-pro
  ];


  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ table table-others ];
  };

  powerManagement.enable = true; # Does this belong in gui.nix?
}
