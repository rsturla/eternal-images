setup:
  @just --unstable docker-setup
  @just --unstable distrobox-setup

docker-setup:
  @echo "Adding user to docker group..."
  @bash -c "sudo usermod -aG docker $(whoami)"

distrobox-setup:
  @echo "Creating default Distrobox containers"
  distrobox assemble create --file /etc/distrobox/distrobox.ini
