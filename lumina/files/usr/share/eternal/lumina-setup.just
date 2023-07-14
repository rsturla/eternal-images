setup:
  @just --unstable setup-docker
  @just --unstable setup-distrobox

setup-docker:
  @echo "Adding user to docker group..."
  @bash -c "sudo usermod -aG docker $(whoami)"

setup-distrobox:
  @echo "Creating default Distrobox containers"
  distrobox assemble create --file /etc/distrobox/distrobox.ini
