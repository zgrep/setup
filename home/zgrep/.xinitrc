xrdb -merge ~/.Xresources
setxkbmap -layout us,ru -variant dvorak,phonetic_dvorak -option compose:ralt,caps:escape
xinput set-float-prop 'SynPS/2 Synaptics TouchPad' 'libinput Accel Speed' .5
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
exec i3
