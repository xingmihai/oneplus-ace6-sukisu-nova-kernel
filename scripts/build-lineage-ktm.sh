#!/usr/bin/env bash
set -euo pipefail

# OnePlus Ace 6 (ktm) / LineageOS 24.0 build helper.
# Run this script from a Linux host with the LineageOS build prerequisites installed.

TOP="${LINEAGE_TOP:-$HOME/android/lineage}"
BRANCH="lineage-24.0"
DEVICE="ktm"

if ! command -v repo >/dev/null 2>&1; then
  echo "error: repo is not installed or not in PATH" >&2
  exit 1
fi

mkdir -p "$TOP"
cd "$TOP"

if [ ! -d .repo ]; then
  repo init -u https://github.com/LineageOS/android.git \
    -b "$BRANCH" --git-lfs --no-clone-bundle
fi

repo sync
source build/envsetup.sh
breakfast "$DEVICE"

cat <<'EOF'

Source preparation is complete.

If this is the first build, extract proprietary files from a device running
LineageOS 24.0 (or use the official installable-zip extraction procedure):

  cd device/oneplus/ktm
  ./extract-files.py

Then build with:

  croot
  brunch ktm

Build output is under $OUT. To integrate SukiSU Nova into the downloaded
kernel source, run scripts/integrate-sukisu-nova.sh from this repository.
EOF
