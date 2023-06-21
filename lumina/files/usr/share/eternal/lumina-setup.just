setup:
  @just --unstable setup-docker

setup-docker:
  @echo "Adding user to docker group..."
  usermod -aG docker $(USER)
