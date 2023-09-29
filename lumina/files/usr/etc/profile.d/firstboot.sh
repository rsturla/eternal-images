if test "$(id -u)" -gt "0" && test -d "$HOME"; then
    if test ! -e "$HOME"/.config/autostart/yafti-firstboot.desktop; then
        mkdir -p "$HOME"/.config/autostart
        cp -f /etc/skel.d/.config/autostart/yafti-firstboot.desktop "$HOME"/.config/autostart
    fi
fi
