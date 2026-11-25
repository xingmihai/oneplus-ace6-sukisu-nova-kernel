#!/usr/bin/env bash
set -euo pipefail

# Integrate SukiSU Nova main into the LineageOS ktm kernel tree.
# The official integration helper links the source into drivers/kernelsu and
# updates the kernel Kconfig/Makefile entries.

TOP="${LINEAGE_TOP:-$HOME/android/lineage}"
KERNEL="$TOP/kernel/oneplus/sm8750"

if [ ! -d "$KERNEL" ]; then
  echo "error: kernel tree not found: $KERNEL" >&2
  echo "run scripts/build-lineage-ktm.sh first" >&2
  exit 1
fi

cd "$KERNEL"

if [ -e drivers/kernelsu ]; then
  echo "SukiSU/KernelSU integration already exists at drivers/kernelsu"
else
  curl -LSs 'https://git.zako.shirkneko.top:20004/shirkneko/SukiSU/raw/branch/main/kernel/setup.sh' \
    | bash -s builtin-new
fi

cat <<'EOF'

SukiSU Nova integration step finished.

Before compiling, review the generated kernel configuration. For the main
branch, the official guide requires CONFIG_KPROBES=y and CONFIG_EXT4_FS=y;
CONFIG_KSU may be built in (y) or as a module (m). Enable CONFIG_KPM=y only
if KPM is required and you accept its stability trade-offs.

Now return to the Android tree and run:

  source build/envsetup.sh
  brunch ktm
EOF
