#!/usr/bin/env bash

set -euox pipefail

rootfs() {
  podman build -f ./Containerfile -t localhost/ostreecontainer:local .
  podman run --name ostreecontainer \
    --cidfile ./.build/containerid \
    localhost/ostreecontainer:local
  CID=$(cat ./.build/containerid)
  trap 'podman rm -f "$CID"' EXIT
  podman export --output ./.build/ostreecontainer.tar "$CID"
  podman rm -f "$CID"

  mkdir -p ./.build/rootfs
  tar -xf ./.build/ostreecontainer.tar -C ./.build/rootfs
  rm -f ./.build/ostreecontainer.tar

  for file in usr/bin/sudo usr/lib/polkit-1/polkit-agent-helper-1 usr/bin/passwd usr/bin/pkexec usr/bin/fusermount3; do
    chmod u+s ./.build/rootfs/$file
  done
}

grub() {
  OS_RELEASE=./.build/rootfs/usr/lib/os-release
  TMPL="./src/grub.cfg.tmpl"
  DEST="./src/grub.cfg"
  PRETTY_NAME="$(source "$OS_RELEASE" >/dev/null && echo "$PRETTY_NAME")"
  sed \
    -e "s|@PRETTY_NAME@|$PRETTY_NAME|g" \
    "$TMPL" >"$DEST"
}

initramfs() {
  cp -r ./.build/rootfs/usr/lib/modules/*/initramfs.img ./.build/initramfs.img
}

load_container() {
  podman pull ghcr.io/rsturla/eternal-linux/lumina:41
  podman save \
    --format oci-dir \
    --output ./.build/rootfs/usr/lib/ostreecontainer \
    ghcr.io/rsturla/eternal-linux/lumina:41
  podman image rm ghcr.io/rsturla/eternal-linux/lumina:41
}

load_flatpaks() {
  mkdir -p ./.build/rootfs/flatpak/repo ./.build/rootfs/var/lib/flatpak
  sudo podman run --rm --privileged --volume ./.build/rootfs/flatpak:/flatpak --volume ./src/flatpaks.txt:/flatpaks.txt --volume ./.build/rootfs/var/lib:/var/lib registry.fedoraproject.org/fedora:41 sh -c '
      set -euox pipefail

      dnf install -y flatpak ostree

      mkdir -p /etc/flatpak/installations.d
      tee /etc/flatpak/installations.d/liveiso.conf <<EOF
[Installation "liveiso"]
Path=/var/lib/flatpak
EOF

      flatpak remote-add --installation=liveiso --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
      grep -v "^#.*" /flatpaks.txt | sort --reverse | while read -r app; do
        echo "Installing ${app} from flathub..."
        for attempt in 1 2 3; do
          if flatpak install --noninteractive -y --installation=liveiso --assumeyes --or-update flathub "${app}"; then
            echo "Successfully installed ${app} on attempt ${attempt}"
            break
          else
            echo "Attempt ${attempt} to install ${app} failed."
            sleep 2
          fi
        done
      done
      flatpak build-update-repo /var/lib/flatpak/repo
      ln -sf /var/lib/flatpak/repo /flatpak/repo
    '
}

squashfs() {
  sudo podman run --rm --privileged --volume ./.build:/build registry.fedoraproject.org/fedora:41 sh -c '
    set -euox pipefail

    dnf install -y squashfs-tools
    mksquashfs /build/rootfs /build/squashfs.img -all-root -noappend
  '
}

iso() {
  mkdir -p ./.build/iso/boot/grub ./.build/iso/LiveOS
  mv ./.build/rootfs/lib/modules/*/vmlinuz ./.build/iso/boot
  mv ./.build/initramfs.img ./.build/iso/boot
  cp src/grub.cfg ./.build/iso/boot/grub
  mv ./.build/squashfs.img ./.build/iso/LiveOS/squashfs.img

  sudo rm -rf ./.build/rootfs
  sudo podman run --rm --privileged --volume ./.build:/build registry.fedoraproject.org/fedora:41 sh -c '
    set -euox pipefail

    ISOROOT=/build/iso
    WORKDIR=/build
    mkdir -p "$ISOROOT"

    dnf install -y grub2 grub2-efi grub2-tools grub2-tools-extra xorriso shim dosfstools
    if [ "$(arch)" == "x86_64" ] ; then
        dnf install -y grub2-efi-x64-modules grub2-efi-x64-cdboot grub2-efi-x64
    elif [ "$(arch)" == "aarch64" ] ; then
        dnf install -y grub2-efi-aa64-modules
    fi

    mkdir -p $ISOROOT/EFI/BOOT
    ARCH_SHORT="$(arch | sed 's/x86_64/x64/g' | sed 's/aarch64/aa64/g')"
    ARCH_32="$(arch | sed 's/x86_64/ia32/g' | sed 's/aarch64/arm/g')"
    cp -avf /boot/efi/EFI/fedora/. $ISOROOT/EFI/BOOT
    cp -avf $ISOROOT/boot/grub/grub.cfg $ISOROOT/EFI/BOOT/BOOT.conf
    cp -avf $ISOROOT/boot/grub/grub.cfg $ISOROOT/EFI/BOOT/grub.cfg
    cp -avf /boot/grub*/fonts/unicode.pf2 $ISOROOT/EFI/BOOT/fonts
    cp -avf $ISOROOT/EFI/BOOT/shim${ARCH_SHORT}.efi "$ISOROOT/EFI/BOOT/BOOT${ARCH_SHORT^^}.efi"
    cp -avf $ISOROOT/EFI/BOOT/shim.efi "$ISOROOT/EFI/BOOT/BOOT${ARCH_32}.efi"

    ARCH_GRUB="$(arch | sed 's/x86_64/i386-pc/g' | sed 's/aarch64/arm64-efi/g')"
    ARCH_OUT="$(arch | sed 's/x86_64/i386-pc-eltorito/g' | sed 's/aarch64/arm64-efi/g')"
    ARCH_MODULES="$(arch | sed 's/x86_64/biosdisk/g' | sed 's/aarch64/efi_gop/g')"

    grub2-mkimage -O $ARCH_OUT -d /usr/lib/grub/$ARCH_GRUB -o $ISOROOT/boot/eltorito.img -p /boot/grub iso9660 $ARCH_MODULES
    grub2-mkrescue -o $ISOROOT/../efiboot.img

    EFI_BOOT_MOUNT=$(mktemp -d)
    mount $ISOROOT/../efiboot.img $EFI_BOOT_MOUNT
    cp -r $EFI_BOOT_MOUNT/boot/grub $ISOROOT/boot/
    umount $EFI_BOOT_MOUNT
    rm -rf $EFI_BOOT_MOUNT

    # https://github.com/FyraLabs/katsu/blob/1e26ecf74164c90bc24299a66f8495eb2aef4845/src/builder.rs#L145
    EFI_BOOT_PART=$(mktemp -d)
    fallocate $WORKDIR/efiboot.img -l 25M
    mkfs.msdos -v -n EFI $WORKDIR/efiboot.img
    mount $WORKDIR/efiboot.img $EFI_BOOT_PART
    mkdir -p $EFI_BOOT_PART/EFI/BOOT
    cp -dRvf $ISOROOT/EFI/BOOT/. $EFI_BOOT_PART/EFI/BOOT
    umount $EFI_BOOT_PART

    ARCH_SPECIFIC=()
    if [ "$(arch)" == "x86_64" ] ; then
        ARCH_SPECIFIC=("--grub2-mbr" "/usr/lib/grub/i386-pc/boot_hybrid.img")
    fi

    xorrisofs \
        -R \
        -V bluefin_boot \
        -partition_offset 16 \
        -appended_part_as_gpt \
        -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B \
        $ISOROOT/../efiboot.img \
        -iso_mbr_part_type EBD0A0A2-B9E5-4433-87C0-68B6B72699C7 \
        -c boot.cat --boot-catalog-hide \
        -b boot/eltorito.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        --grub2-boot-info \
        -eltorito-alt-boot \
        -e \
        --interval:appended_partition_2:all:: \
        -no-emul-boot \
        -vvvvv \
        -iso-level 3 \
        -o $WORKDIR/installer.iso \
        "${ARCH_SPECIFIC[@]}" \
        $ISOROOT
  '
}

sudo rm -rf ./.build
mkdir -p ./.build
rootfs
grub
initramfs
load_container
load_flatpaks
squashfs
iso
