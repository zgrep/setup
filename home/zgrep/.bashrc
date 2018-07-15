# If return code isn't 0, a nice red color and show it to me, please.
# Then give me user@host. Then my current directory.
# And finally, the history number of the command, and the $ or # symbol.
export PS1='$(s=$?; [ $s == 0 ] || echo "\[\033[0;31m\]$s ")\[\033[0;34m\]\u@\H \[\033[0;32m\]\w\n\[\033[0;34m\]\!\[\033[0;00m\] \$ '

# Have as many dots as our history number, and then some more.
# Makes it look nice.
export PS2='$(expr \! - 1 | tr '1234567890' '.').. '

# Colored ls that shows hidden files.
alias ls='ls -a --color=auto'

# Editor variables and alias.
export EDITOR='vim'
export VISUAL="$EDITOR"
alias e="$EDITOR"

# History
export HISTCONTROL=ignoredups:erasedups  
shopt -s histappend

# Damn you, bash.
alias time='command time'

# k
# alias ok='~/vers/ok/repl.js'
# alias k='rlwrap ~/down/k'
