{ config, pkgs, ... }:

{
  environment.variables = {
    EDITOR = "vim";
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

  environment.systemPackages = with pkgs; [ vim ];

  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    vim = vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = ''
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

        " Make folds work nicely.
        set foldopen-=block
        set fcl=all

        " No mode line, I guess.
        set modelines=0
        set nomodeline
      '';
    };
  };
}
