#!/usr/bin/bash

set -euox pipefail

# Assign chunkah xattr components to non-RPM files so they get merged into
# the correct RPM component layers.  Files owned by RPMs are already handled
# by chunkah's rpmdb component repo; this script covers cross-cutting content
# generated at install time that should land in the same layer as the RPM
# that produced it.

# ── Kernel modules ────────────────────────────────────────────────────────
# The .ko.xz files are RPM-owned (kernel-core, kernel-modules, etc.) and
# chunkah groups them under the "kernel" SRPM component.  However dracut
# generates initramfs.img (~237 MiB) and other files (System.map, config,
# .vmlinuz.hmac) at install time which are unowned.  Tag the entire
# /usr/lib/modules tree so they merge into the rpm/kernel component.
for kdir in /usr/lib/modules/*/; do
  setfattr -n user.component -v "rpm/kernel" "$kdir"
  find "$kdir" -mindepth 1 -exec setfattr -n user.component -v "rpm/kernel" {} \;
done

# ── SELinux compiled policy ───────────────────────────────────────────────
# The compiled policy modules under /etc/selinux are generated at install
# time by selinux-policy-targeted (~14 MiB, 1300+ files).  They all change
# together when the selinux-policy SRPM is updated.
setfattr -n user.component -v "rpm/selinux-policy" /etc/selinux
find /etc/selinux -mindepth 1 -exec setfattr -n user.component -v "rpm/selinux-policy" {} \;
