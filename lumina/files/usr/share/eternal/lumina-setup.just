setup:
  @just --unstable setup-docker

setup-docker:
  @echo "Adding user to docker group..."
  @bash -c "sudo usermod -aG docker $(whoami)"
