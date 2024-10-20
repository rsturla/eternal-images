clean:
  podman image prune --all --force
  podman volume prune --force
  flatpak uninstall --unused
  rpm-ostree cleanup --base --repomd
  sudo podman image prune --all --force
  sudo podman volume prune --force
  docker image prune --all --force
  docker volume prune --all --force
