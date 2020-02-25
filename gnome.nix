{ lib, pkgs, ... }:

let
    mkForce = lib.mkForce;
in {
    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "dvorak";
        xkbOptions = "caps:escape,compose:ralt";
        displayManager.gdm.enable = true;
        desktopManager.xterm.enable = mkForce false;
        desktopManager.gnome3 = {
            enable = true;
            extraGSettingsOverrides = ''
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

                [org.gnome.nautilus.preferences]
                search-view='list-view'
                default-folder-viewer='list-view'
                show-create-link=true
                search-filter-time-type='last_modified'

                [org.gnome.nautilus.list-view]
                default-column-order=['name', 'size', 'detailed_type', 'type', 'owner', 'group', 'permissions', 'where', 'date_modified', 'date_modified_with_time', 'date_accessed', 'recency', 'starred']
                default-visible-columns=['name', 'size', 'detailed_type', 'date_modified_with_time', 'date_accessed', 'owner', 'group', 'permissions']
                default-zoom-level='small'

                [org.gnome.desktop.interface]
                clock-show-date=true
                clock-show-seconds=true
                clock-show-weekday=true
                gtk-enable-primary-paste=false
                show-battery-percentage=true
                text-scaling-factor=0.92000000000000004
                monospace-font-name='Source Code Pro 11'
                document-font-name='Cantarell 11'
                font-name='Cantarell 11'
                gtk-im-module='gtk-im-context-simple'
                gtk-theme='Adementary'
                icon-theme='Adwaita'

                [org.gnome.desktop.wm.preferences]
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

                [org.gnome.settings-daemon.plugins.xsettings]
                antialiasing='rgba'
                hinting='full'
            '';
        };
    };

    services.gnome3.core-os-services.enable = true;
    services.gnome3.core-shell.enable = true;
    services.gnome3.core-utilities.enable = true;
    services.gnome3.games.enable = false;
    services.geoclue2.enable = mkForce false;
    services.dleyna-renderer.enable = mkForce false;
    services.dleyna-server.enable = mkForce false;
    services.gnome3.at-spi2-core.enable = mkForce false;
    services.gnome3.evolution-data-server.enable = mkForce false;
    programs.gnome-documents.enable = mkForce false;
    services.gnome3.gnome-online-accounts.enable = mkForce false;
    services.gnome3.gnome-user-share.enable = mkForce false;
    programs.seahorse.enable = mkForce false;
    services.avahi.enable = mkForce false;
    services.telepathy.enable = mkForce false;

    environment.gnome3.excludePackages = (with pkgs.gnome3; [
      cheese epiphany geary gedit gnome-calculator
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      yelp totem gnome-weather
      gnome-software gnome-photos gnome-music
      gnome-maps gnome-logs
    ]);

    environment.systemPackages = (with pkgs.gnome3; [
        gnome-power-manager
        gnome-session
        networkmanagerapplet
        dconf-editor
        gnome-tweaks
    ]) ++ [ pkgs.adementary-theme ];
}
