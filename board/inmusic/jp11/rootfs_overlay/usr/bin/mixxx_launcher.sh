#!/bin/sh
# MIXXX Launcher — firmware-resident version
# Uses device-native Qt5.15.2 from /usr/qt/lib
# EGLFS renders directly to framebuffer with Mali r1p0 GPU driver.

# ── Fix Mali device permissions ──
[ -c /dev/mali0 ] && chmod 666 /dev/mali0 2>/dev/null

# ── Library path: device-native Qt5.15.2 ──
export LD_LIBRARY_PATH="/usr/qt/lib:/usr/lib:$LD_LIBRARY_PATH"

# ── Qt5 environment ──
export QT_PLUGIN_PATH="/usr/qt/plugins"
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_emu
export QT_QPA_EGLFS_KMS_ATOMIC=1
export QT_QPA_EGLFS_ROTATION=90
export QT_QPA_EGLFS_DEBUG=0

# ── GPU performance governor ──
for g in /sys/class/devfreq/*mali*/governor /sys/class/devfreq/*gpu*/governor; do
    [ -f "$g" ] && echo performance > "$g" 2>/dev/null
done

# ── Home ──
export HOME=/root
export XDG_RUNTIME_DIR=/tmp

# ── CPU shielding: pin MIXXX to cores 2-3 with real-time FIFO priority 99 ──
exec taskset -c 2,3 chrt -f 99 /usr/bin/mixxx -platform eglfs \
  --settingsPath /root/.mixxx \
  --resourcePath /usr/share/mixxx
