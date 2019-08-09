{ lib, pkgs, ... }:

let
    mkForce = lib.mkForce;
in {
    services.xserver = {
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

    environment.systemPackages = (with pkgs.gnome3; [
        gnome-terminal gnome-disk-utility
        gnome-power-manager simple-scan
        nautilus file-roller
        eog evince
        gnome-session
        gnome-screenshot
        networkmanagerapplet
        dconf-editor
    ]);
}
