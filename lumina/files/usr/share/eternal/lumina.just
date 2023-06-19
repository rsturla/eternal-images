distrobox-create:
  distrobox assemble create --file /etc/distrobox/distrobox.ini

distrobox-replace:
  distrobox assemble create --replace --file /etc/distrobox/distrobox.ini

distrobox-remove:
  distrobox assemble rm --file /etc/distrobox/distrobox.ini
