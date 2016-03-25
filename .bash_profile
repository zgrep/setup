# ~/.bash_profile

# If return code isn't 0, a nice red color and show it to me, please.
# Then give me user@host. Then my current directory.
# And finally, the history number of the command, and the $ or # symbol.
export PS1='$([ $? == 0 ] || echo "\[\033[0;31m\]$? ")\[\033[0;34m\]\u@\H \[\033[0;32m\]\w\n\[\033[0;34m\]\!\[\033[0;00m\] \$ '

# Have as many dots as our history number, and then some more.
# Makes it look nice.
export PS2='$(expr \! - 1 | tr '1234567890' '.').. '

# Colored ls that shows hidden files.
alias ls='ls -aG'

# Editor variables and alias.
export EDITOR='subl'
export VISUAL='subl -w'
alias e="$EDITOR"

# PATH manipulations: rust nightly installed things
export PATH="$PATH:~/.multirust/toolchains/nightly/cargo/bin"

# For secrets and whatnot.
source ~/.bash_profile_secret