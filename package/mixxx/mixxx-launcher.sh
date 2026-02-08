#!/bin/sh

# ==========================================
# 1. SYSTEM CLEANUP (The "Kill Switch")
# ==========================================
echo ">>> stopping stock engine..."
systemctl stop engine
systemctl stop az01-script-runner
killall -9 EngineDJ Stagehand mixxx 2>/dev/null

# ==========================================
# 2. FILESYSTEM & PATHS
# ==========================================
# Remount /data as RW for persistent settings and library
mount -o remount,rw /data

# XDG Paths (Keep config clean in /data)
# MIXXX_ROOT is set to /usr for system-wide Buildroot installation
export MIXXX_ROOT="/usr"
export XDG_CONFIG_HOME="/data/mixxx-settings/config"
export XDG_DATA_HOME="/data/mixxx-settings/data"
export XDG_CACHE_HOME="/data/mixxx-settings/cache"
export XDG_RUNTIME_DIR="/tmp/runtime-mixxx"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_RUNTIME_DIR"
chmod 0700 "$XDG_RUNTIME_DIR"

# Library Injection
export LD_LIBRARY_PATH="$MIXXX_ROOT/lib:/usr/lib:/lib"
export QT_PLUGIN_PATH="/usr/lib/qt/plugins"
export QML2_IMPORT_PATH="/usr/qml"

# ==========================================
# 3. GRAPHICS TUNING (Merged Strategy)
# ==========================================
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms
export QT_QPA_EGLFS_ALWAYS_SET_MODE=1
export QSG_RENDER_LOOP=basic

# Optimizations for Rockchip Kernel 6.1
export QT_QPA_EGLFS_KMS_ATOMIC=1    # Better frame flipping
export QT_QPA_EGLFS_HIDECURSOR=1    # No mouse arrow

# Force Modern GLES 3.2 & GLSL 320
export QT_OPENGL_ES_VERSION=3.2
export MESA_GLES_VERSION_OVERRIDE=3.2
export MESA_GLSL_VERSION_OVERRIDE=320

# ==========================================
# 4. HARDWARE ALIGNMENT
# ==========================================
if [ -f /sys/firmware/devicetree/base/inmusic,product-code ]; then
    APPNAME=$(cat /sys/firmware/devicetree/base/inmusic,product-code)
else
    APPNAME="generic"
fi

# Source native rotation
[ -f /usr/Engine/Scripts/setup-screenrotation.sh ] && . /usr/Engine/Scripts/setup-screenrotation.sh "$APPNAME"

# Re-apply IRQ Pinning (Audio -> Core 3)
[ -f /usr/Engine/Scripts/setup-prerequisites.sh ] && /usr/Engine/Scripts/setup-prerequisites.sh "$APPNAME"

# ==========================================
# 5. EXECUTION
# ==========================================
# Priority 85: High enough to beat everything else, low enough to let ALSA hardware breathe.
echo ">>> launching mixxx (RT Priority 85, Cores 1-3)..."

exec taskset -c 1,2,3 chrt -f 85 "$MIXXX_ROOT/bin/mixxx" \
    --resourcePath "$MIXXX_ROOT/share/mixxx" \
    --settingsPath "$XDG_CONFIG_HOME" \
    --controllerDebug \
    --developer

# ==========================================
# 6. FAILSAFE
# ==========================================
if [ $? -ne 0 ]; then
    echo "!!! Mixxx crashed. Restoring Engine..."
    systemctl start engine
    systemctl start az01-script-runner
fi
