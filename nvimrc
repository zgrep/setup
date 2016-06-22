" ~/.config/nvim/init.vim

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

" Count sentences command.
command! -nargs=? CountSentences execute '<args>s/\[\.\]\|\.[ "]\|\.$//gn|noh'
