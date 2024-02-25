# Eternal Images

A collection of Immutable Linux Desktop images from the Eternal Linux project.  All images provided are highly opinionated and represent my personal preferences for a Linux desktop. Feel free to clone and modify these images to suit your own needs.

## Images

### Lumina

<!-- Table with an overview.  Columns should be Desktop Environment | Intended Usage | Description | Is Stable -->

| Desktop Environment | Intended Usage | Description | Is Stable | ISO |
| ------------------- | -------------- | ----------- | --------- | --- |
| GNOME               | Development    | A desktop optimised for DevOps | Yes | [Regular](https://download.eternal.sturla.tech/lumina/lumina-39.iso) / [NVIDIA](https://download.eternal.sturla.tech/lumina/lumina-39-nvidia.iso) |

![Lumina Desktop](./_assets/lumina-desktop.png)
> The Lumina Desktop Environment featuring Distrobox and VSCode

An opinionated development environment featuring various tools for development and productivity baked in.
This image is perfect for any DevOps professionals who want to get up and running with a rock-solid desktop quickly.

Key features of this image include:
- Containerisation with Docker, Podman and Distrobox
- Virtualization using QEMU/KVM with virt-manager
- Development packages managed with DevPod and Nix
- Visual Studio Code
- Starship Bash prompt with Atuin history
- Additional CLI tools

#### Usage

We build and publish this image to GitHub Container registry.  To use this image, you will need to have pre-installed the Fedora Silverblue desktop and run the following commands:

```bash
$ rpm-ostree rebase ostree-unverified-registry:ghcr.io/rsturla/eternal-linux/lumina:39
$ systemctl reboot
$ eternal setup
```

When the system reboots, you will be presented with the Lumina desktop environment.
