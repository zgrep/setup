# Adapted from nixos/modules/services/x11/desktop-managers/gnome3.nix revision
# 452f7e14d4f4bf41400350917685e2ad98590b28 with things that I dislike changed
# or removed, and with some personal tweaks.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.gnome3;
  serviceCfg = config.services.gnome3;

  # Prioritize nautilus by default when opening directories
  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  defaultFavoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'org.gnome.Epiphany.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Music.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop' ]
  '';

  nixos-gsettings-desktop-schemas = let
    defaultPackages = with pkgs; [ gsettings-desktop-schemas gnome3.gnome-shell ];
  in
  pkgs.runCommand "nixos-gsettings-desktop-schemas" { preferLocalBuild = true; }
    ''
     mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${concatMapStrings
        (pkg: "cp -rf ${pkg}/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas\n")
        (defaultPackages ++ cfg.extraGSettingsOverridePackages)}

     cp -f ${pkgs.gnome3.gnome-shell}/share/gsettings-schemas/*/glib-2.0/schemas/*.gschema.override $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cat - > $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
       [org.gnome.desktop.background]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}'

       [org.gnome.desktop.screensaver]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath}'

       ${cfg.favoriteAppsOverride}

       ${cfg.extraGSettingsOverrides}
     EOF

     ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    '';

in (mkMerge [

  {
    services.xserver.displayManager.sessionPackages = [ pkgs.gnome3.gnome-session.sessions ];

    environment.extraInit = ''
      ${concatMapStrings (p: ''
        if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
          export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
        fi

        if [ -d "${p}/lib/girepository-1.0" ]; then
          export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
          export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
        fi
      '') cfg.sessionPath}
    '';

    environment.systemPackages = cfg.sessionPath;

    environment.sessionVariables.GNOME_SESSION_DEBUG = mkIf cfg.debug "1";

    # Override GSettings schemas
    environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

    # On the hardened profile, we get an error: "GSlice: assertion failed: aligned_memory == (gpointer) addr"
    # This fixes that, apparently.
    # environment.sessionVariables.G_SLICE = "always-malloc";

    # If gnome3 is installed, build vim for gtk3 too.
    nixpkgs.config.vim.gui = "gtk3";
  }

  {
    # Necessary, and/or miscellaneous, gnome tools and services.
    hardware.pulseaudio.enable = mkDefault true;
    programs.dconf.enable = true;
    security.polkit.enable = true;
    services.accounts-daemon.enable = true;
    services.gnome3.tracker-miners.enable = mkDefault true;
    services.gnome3.tracker.enable = mkDefault true;
    services.hardware.bolt.enable = mkDefault true;
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.xserver.libinput.enable = mkDefault true; # for controlling touchpad settings via gnome control center

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    # :(
    networking.networkmanager.enable = mkDefault true;

    services.xserver.updateDbusEnvironment = true;

    # gnome has a custom alert theme but it still
    # inherits from the freedesktop theme.
    environment.systemPackages = with pkgs; [
      sound-theme-freedesktop
    ];

    # Needed for themes and backgrounds
    environment.pathsToLink = [
      "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
    ];
  }

  {
    services.colord.enable = mkDefault true;
    services.gnome3.chrome-gnome-shell.enable = mkDefault true;
    services.gnome3.glib-networking.enable = true;
    services.gnome3.gnome-settings-daemon.enable = true;
    services.gvfs.enable = true;
    services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));

    systemd.packages = with pkgs.gnome3; [
      gnome-session
      gnome-shell
    ];

    services.udev.packages = with pkgs.gnome3; [
      # Force enable KMS modifiers for devices that require them.
      # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1443
      mutter
    ];

    xdg.portal.extraPortals = [
      pkgs.gnome3.gnome-shell
    ];

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-shell.bst
    environment.systemPackages = with pkgs.gnome3; [
      adwaita-icon-theme
      gnome-backgrounds
      gnome-bluetooth
      gnome-color-manager
      gnome-control-center
      gnome-getting-started-docs
      gnome-shell
      gnome-shell-extensions
      gnome-themes-extra
      pkgs.nixos-artwork.wallpapers.simple-dark-gray
      pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom
      pkgs.gnome-user-docs
      pkgs.orca
      pkgs.glib # for gsettings
      pkgs.gnome-menus
      pkgs.gtk3.out # for gtk-launch
      pkgs.hicolor-icon-theme
      pkgs.shared-mime-info # for update-mime-database
      pkgs.xdg-user-dirs # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
    ];
  }

  # Enable soft realtime scheduling, only supported on wayland
  (mkIf serviceCfg.experimental-features.realtime-scheduling {
    security.wrappers.".gnome-shell-wrapped" = {
      source = "${pkgs.gnome3.gnome-shell}/bin/.gnome-shell-wrapped";
      capabilities = "cap_sys_nice=ep";
    };

    systemd.user.services.gnome-shell-wayland = let
      gnomeShellRT = with pkgs.gnome3; pkgs.runCommand "gnome-shell-rt" {} ''
        mkdir -p $out/bin/
        cp ${gnome-shell}/bin/gnome-shell $out/bin
        sed -i "s@${gnome-shell}/bin/@${config.security.wrapperDir}/@" $out/bin/gnome-shell
      '';
    in {
      # Note we need to clear ExecStart before overriding it
      serviceConfig.ExecStart = ["" "${gnomeShellRT}/bin/gnome-shell"];
      # Do not use the default environment, it provides a broken PATH
      environment = mkForce {};
    };
  })

  # Adapted from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-utilities.bst
  {
    environment.systemPackages = with pkgs.gnome3; [
      baobab
      cheese
      eog
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-logs
      gnome-maps
      gnome-screenshot
      gnome-system-monitor
      gnome-weather
      nautilus
      simple-scan
      yelp
    ];

    programs.evince.enable = true;
    programs.file-roller.enable = true;
    programs.gnome-disks.enable = true;
    programs.gnome-terminal.enable = true;
    services.gnome3.sushi.enable = true;

    # Let nautilus find extensions
    # TODO: Create nautilus-with-extensions package
    environment.sessionVariables.NAUTILUS_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-3.0";

    # Override default mimeapps for nautilus
    environment.sessionVariables.XDG_DATA_DIRS = [ "${mimeAppsList}/share" ];

    environment.pathsToLink = [
      "/share/nautilus-python/extensions"
    ];
  }

  {
    environment.systemPackages = (with pkgs.gnome3; [
      gnome-power-manager
      gnome-session
      networkmanagerapplet
      dconf-editor
      gnome-tweaks
    ]) ++ (with pkgs; [
      adementary-theme
      gnomeExtensions.caffeine
      gnomeExtensions.workspace-matrix
      # Make Qt5 apps look like GTK apps (nixpkgs 21.03).
      # qt5.qtbase.gtk
    ]);

    programs.gpaste.enable = true;
  }

])
