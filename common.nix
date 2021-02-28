# Common things I'll want on servers, desktops, laptop, etc.

{ config, pkgs, modulesPath, ... }:

{
  # Hardened options, though not just yet. They seem to break too much. :(
  # imports = [ (modulesPath + "/profiles/hardened.nix") ];

  i18n.defaultLocale = "en_US.UTF-8";

  # Just in case.
  networking.firewall.enable = true;

  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less";
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

  environment.systemPackages = with pkgs; [ neovim ];

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    neovim = neovim.override {
      configure.customRC = ''
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

        " Spaces and indentation.
        filetype plugin indent on
        set expandtab tabstop=4 shiftwidth=4 softtabstop=4

        " Show certain hidden characters.
        set list
        set listchars=tab:>-,nbsp:_,conceal:*

        " Wrap text onto next line nicely.
        set linebreak

        " Make folds work nicely.
        set foldopen-=block
        set fcl=all

        " No mode line, I guess.
        set modelines=0
        set nomodeline

        " I have a light terminal background.
        set background=light
      '';
    };
  };
}
