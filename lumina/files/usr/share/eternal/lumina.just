distrobox-create:
  distrobox assemble create --file /etc/distrobox/distrobox.ini

distrobox-replace:
  distrobox assemble create --replace --file /etc/distrobox/distrobox.ini

distrobox-remove:
  distrobox assemble rm --file /etc/distrobox/distrobox.ini

distrobox-upgrade:
  echo 'Installing latest git snapshot of Distrobox'
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local
