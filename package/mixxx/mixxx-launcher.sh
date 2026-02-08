#!/bin/sh

# Mixxx Launcher for Rockchip Engine OS devices
# Optimized for real-time audio and direct-to-hardware graphics

# Core Affinity: Use isolated cores 1, 2, 3 for Mixxx
# Core 0 is reserved for system tasks
AFFINITY="1-3"

# Real-time priority: FIFO 99
PRIORITY=99

# Direct Graphics: DRM/KMS environment variables
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_ALWAYS_SET_MODE=1
export QT_QPA_EGLFS_KMS_ATOMIC=1
export QT_QPA_EGLFS_HIDECURSOR=1

# Rockchip specific GLES/EGL environment
export QT_QPA_EGLFS_KMS_CONFIG=/etc/mixxx/kms.conf

# Force OpenGL ES 3.2 and GLSL ES 3.20
export MESA_GLES_VERSION_OVERRIDE=3.2
export MESA_GLSL_VERSION_OVERRIDE=320

# PulseAudio/Jack optimizations if used
# export PULSE_LATENCY_MSEC=1

echo "Starting Mixxx on cores $AFFINITY with priority $PRIORITY..."

# Launch Mixxx with affinity and real-time priority
exec taskset -c $AFFINITY chrt -f $PRIORITY mixxx "$@"
