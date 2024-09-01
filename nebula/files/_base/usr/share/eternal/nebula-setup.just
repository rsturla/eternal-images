setup:
  @just setup-docker
  @just setup-wireshark
  @just setup-nordvpn
  @echo "Setup complete!"
  @echo "Please reboot to complete the setup process."

setup-docker:
  @echo "Adding user to docker group..."
  @bash -c "sudo usermod -aG docker $(whoami)"

setup-wireshark:
  @echo "Adding user to wireshark group..."
  @bash -c "sudo usermod -aG wireshark $(whoami)"

setup-nordvpn:
  @echo "Adding user to nordvpn group..."
  @bash -c "sudo usermod -aG nordvpn $(whoami)"
