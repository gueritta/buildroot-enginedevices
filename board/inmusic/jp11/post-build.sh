#!/bin/bash
# Post-build script for JP11 (Denon Prime Go)
# Ensures the mixxx.service is enabled in the target rootfs

TARGET_DIR="$1"
BOARD_DIR="$(dirname "$0")"

# NOTE: mixxx.service is intentionally NOT enabled by default.
# It has Conflicts=engine.service and Before=engine.service,
# so enabling it would prevent Engine DJ from starting on boot.
# Users who want MIXXX should either:
#   1. Use the SD card deployment (scripts/deploy-to-device.sh) for switchable dual-boot
#   2. Manually enable: systemctl enable mixxx.service

# Make launcher executable
chmod 755 "$TARGET_DIR/usr/bin/mixxx_launcher.sh" 2>/dev/null || true

# Ensure USB gadget scripts are executable
chmod 755 "$TARGET_DIR/usr/sbin/usb-gadget-eth.sh" 2>/dev/null || true
