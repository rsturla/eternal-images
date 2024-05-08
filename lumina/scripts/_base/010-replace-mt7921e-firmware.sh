#!/usr/bin/env bash

set -euox pipefail

mkdir -p /tmp/mediatek-firmware
curl -Lo /tmp/mediatek-firmware/WIFI_MT7922_patch_mcu_1_1_hdr.bin https://gitlab.com/kernel-firmware/linux-firmware/-/raw/6b91b2ef6f4173099c1434e5d7c552e51814e26e/mediatek/WIFI_MT7922_patch_mcu_1_1_hdr.bin?inline=false
curl -Lo /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7922_1.bin https://gitlab.com/kernel-firmware/linux-firmware/-/raw/6b91b2ef6f4173099c1434e5d7c552e51814e26e/mediatek/WIFI_RAM_CODE_MT7922_1.bin?inline=false
curl -Lo /tmp/mediatek-firmware/WIFI_MT7961_patch_mcu_1_2_hdr.bin https://gitlab.com/kernel-firmware/linux-firmware/-/raw/0a18a7292a66532633d9586521f0b954c68a9fbc/mediatek/WIFI_MT7922_patch_mcu_1_1_hdr.bin?inline=false
curl -Lo /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7961_1.bin https://gitlab.com/kernel-firmware/linux-firmware/-/raw/0a18a7292a66532633d9586521f0b954c68a9fbc/mediatek/WIFI_RAM_CODE_MT7922_1.bin?inline=false
xz --check=crc32 /tmp/mediatek-firmware/WIFI_MT7922_patch_mcu_1_1_hdr.bin
xz --check=crc32 /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7922_1.bin
xz --check=crc32 /tmp/mediatek-firmware/WIFI_MT7961_patch_mcu_1_2_hdr.bin
xz --check=crc32 /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7961_1.bin
mv -vf /tmp/mediatek-firmware/* /usr/lib/firmware/mediatek/
rm -rf /tmp/mediatek-firmware
