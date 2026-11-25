#!/sbin/sh

## AnyKernel3 project
## OnePlus Ace 6 (ktm) / LineageOS 24.0 / SM8750

properties() { '
  kernel.string=OnePlus Ace 6 ktm — LineageOS 24.0 — SukiSU-Nova
  do.devicecheck=1
  do.modules=0
  do.systemless=0
  do.cleanup=1
  do.cleanuponabort=0
  device.name1=ktm
  device.name2=PLQ110
  supported.versions=17
'; } # end properties

# A/B device boot partition. AnyKernel3 resolves the active slot.
BLOCK=/dev/block/by-name/boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# Replace only the kernel payload and preserve the existing ramdisk/vendor data.
. tools/ak3-core.sh;
split_boot; # preserve the existing ramdisk
flash_boot;
EOF
