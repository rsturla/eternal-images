setup:
  @echo "Adding user to docker group..."
  usermod -aG docker $(USER)
