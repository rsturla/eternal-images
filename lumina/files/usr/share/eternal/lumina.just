distrobox-replace:
  @echo "Recreating default Distrobox containers"
  distrobox assemble create --replace --file /etc/distrobox/distrobox.ini

distrobox-remove:
  @echo "Deleting default Distrobox containers"
  distrobox assemble rm --file /etc/distrobox/distrobox.ini

distrobox-upgrade:
  @echo "Installing latest git snapshot of Distrobox"
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix ~/.local
