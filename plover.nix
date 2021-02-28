# Learning to stenotype!

{ pkgs, ... }:

let
  # I want the newer version, but also I'm lazy.
  plover-appimage = builtins.fetchurl {
    url = "https://github.com/openstenoproject/plover/releases/download/weekly-v4.0.0.dev8%2B66.g685bd33/plover-4.0.0.dev8.66.g685bd33-x86_64.AppImage";
    sha256 = "0074z4c6pw16x2j9ic2k3054qfxmi53lysnxyqynz73l2vi0l9hm";
  };
in {
  environment.systemPackages = [
    (pkgs.callPackage pkgs.makeDesktopItem {
      name = "plover";
      desktopName = "Plover";
      exec = "env XKB_DEFAULT_RULES=us ${pkgs.appimage-run}/bin/appimage-run ${plover-appimage}";
    })
    pkgs.featherpad # A QT text editor will run under XWayland, and so Plover will work there.
  ];

  # Atreus → Plover.
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="a1e5", MODE="0666"
  '';
}
