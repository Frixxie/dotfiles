if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# oneko -rv -tora -tofocus &

xset b off &

set bell-style none &

picom -f -D 1 &

redshift &

xbacklight -set 100 &

# enable tapping for left click on touchpad
xinput --set-prop 'ELAN469D:00 04F3:304B Touchpad' 'libinput Tapping Enabled' 1

feh --bg-scale ~/wallpapers/the-neon-shallows-oned-v2.png &

#xrandr --output HDMI-0 --auto --right-of DVI-D-0

#xrandr --setmonitor master auto HDMI-0,DVI-D-0

nm-applet &

flameshot &

blueman-applet &

dwmblocks &

dropbox start &

exec dbus-launch --exit-with-session dwm

#exec spectrwm
