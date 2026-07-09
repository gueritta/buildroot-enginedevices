MIXXX_VERSION = 2.5.6
MIXXX_SOURCE = mixxx-$(MIXXX_VERSION).tar.gz
MIXXX_SITE = https://github.com/mixxxdj/mixxx/archive/refs/tags/$(MIXXX_VERSION).tar.gz
MIXXX_SITE = $(call github,mixxxdj,mixxx,$(MIXXX_VERSION))
MIXXX_INSTALL_STAGING = NO
MIXXX_INSTALL_TARGET = YES
MIXXX_LICENSE = GPLv2
# disable symlinks to avoid "failed to create symbolic link '…/src/test' because existing path cannot be removed: Is a directory"
MIXXX_CONF_OPTS = \
    -DUSE_SYMLINKS=OFF \
    -DQT6=OFF \
    -DOPTIMIZE=native \
    -DQT_QPA_PLATFORM=eglfs \
    -DBUILD_BENCH=OFF \
    -DCMAKE_DISABLE_FIND_PACKAGE_X11=ON \
    -DENGINEPRIME=OFF

# ARMv7ve NEON DSP Optimization
MIXXX_HW_FLAGS = \
    -march=armv7ve \
    -mtune=cortex-a17 \
    -mfpu=neon-vfpv4 \
    -mfloat-abi=hard \
    -O3 \
    -ftree-vectorize \
    -funsafe-math-optimizations

# Inject HW flags into target C/CXX flags
MIXXX_CONF_OPTS += \
    -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(MIXXX_HW_FLAGS)" \
    -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(MIXXX_HW_FLAGS)"

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
MIXXX_CONF_OPTS += -DOPENGL=DESKTOP
else ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
MIXXX_CONF_OPTS += -DOPENGL=ES -DQGLES2=ON -DQGLES3=ON
endif
# MIXXX_DEPENDENCIES = \
# 	protobuf vamp-plugin-sdk rubberband soundtouch \
# 	libid3tag taglib \
# 	lame libogg libmad libvorbis libmp4v2 faad2 opusfile wavpack \
# 	libshout libsndfile portmidi portaudio \
# 	sqlite upower lilv libopenmpt-modplug \
# 	qt5-declarative qtkeychain-qt5 qt5-svg

# Dependency list put together from
# 1. https://github.com/mixxxdj/mixxx/wiki/Compiling-On-Linux#arch--derivatives
# 2. https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=mixxx-git
# 3. CMakeLists.txt shipped with mixxx
MIXXX_DEPENDENCIES = \
	chromaprint \
	hidapi \
	lame \
	libogg \
	libsndfile \
	libusb \
	libvorbis \
	portaudio \
	portmidi \
	protobuf \
	protobuf-c \
	rubberband \
	taglib \
	upower \
	libebur128 \
	qt5base \
	qt5declarative \
	qt5script \
	libsoundtouch \
	ms-gsl \
	sqlite \
	gtest

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
MIXXX_DEPENDENCIES += libgl
else ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
MIXXX_DEPENDENCIES += libgles
endif

ifeq ($(BR2_STATIC_DEPS),y)
MIXXX_CONF_OPTS += -DSTATIC_LIBS=ON
endif

ifeq ($(BR2_PACKAGE_MIXXX_INSTALL_USER_UDEV_RULES),y)
MIXXX_CONF_OPTS += -DINSTALL_USER_UDEV_RULES=ON
else
MIXXX_CONF_OPTS += -DINSTALL_USER_UDEV_RULES=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_FAAD),y)
MIXXX_DEPENDENCIES += faad2 mp4v2
MIXXX_CONF_OPTS += -DFAAD=ON
else
MIXXX_CONF_OPTS += -DFAAD=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_KEYFINDER),y)
MIXXX_CONF_OPTS += -DKEYFINDER=ON
ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_KEYFINDER_DYNAMIC),y)
MIXXX_DEPENDENCIES += libkeyfinder
else
MIXXX_DEPENDENCIES += fftw3
endif
else
MIXXX_CONF_OPTS += -DKEYFINDER=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_MODPLUG),y)
MIXXX_DEPENDENCIES += libmodplug
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_BROADCAST),y)
MIXXX_DEPENDENCIES += libshout
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_BULK),y)
MIXXX_DEPENDENCIES += libusb
MIXXX_CONF_OPTS += -DBULK=ON
else
MIXXX_CONF_OPTS += -DBULK=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_HID),y)
MIXXX_DEPENDENCIES += hidapi
MIXXX_CONF_OPTS += -DHID=ON
else
MIXXX_CONF_OPTS += -DHID=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_LILV),y)
MIXXX_DEPENDENCIES += lilv
MIXXX_CONF_OPTS += -DLILV=ON
else
MIXXX_CONF_OPTS += -DLILV=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_MAD),y)
MIXXX_DEPENDENCIES += libmad libid3tag
MIXXX_CONF_OPTS += -DMAD=ON
else
MIXXX_CONF_OPTS += -DMAD=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_MODPLUG),y)
MIXXX_DEPENDENCIES += libmodplug
MIXXX_CONF_OPTS += -DMODPLUG=ON
else
MIXXX_CONF_OPTS += -DMODPLUG=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_OPUS),y)
MIXXX_DEPENDENCIES += opus opusfile
MIXXX_CONF_OPTS += -DOPUS=ON
else
MIXXX_CONF_OPTS += -DOPUS=OFF
endif

ifeq ($(BR2_PACKAGE_QTKEYCHAIN),y)
MIXXX_DEPENDENCIES += qtkeychain
MIXXX_CONF_OPTS += -DQTKEYCHAIN=ON
else
MIXXX_CONF_OPTS += -DQTKEYCHAIN=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_WAVPACK),y)
MIXXX_DEPENDENCIES += wavpack
MIXXX_CONF_OPTS += -DWAVPACK=ON
else
MIXXX_CONF_OPTS += -DWAVPACK=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_VINYLCONTROL),y)
MIXXX_CONF_OPTS += -DVINYLCONTROL=ON
else
MIXXX_CONF_OPTS += -DVINYLCONTROL=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_BROADCAST),y)
MIXXX_CONF_OPTS += -DBROADCAST=ON
else
MIXXX_CONF_OPTS += -DBROADCAST=OFF
endif

ifeq ($(BR2_PACKAGE_MIXXX_SUPPORT_LOCALECOMPARE),y)
MIXXX_CONF_OPTS += -DLOCALECOMPARE=ON
else
MIXXX_CONF_OPTS += -DLOCALECOMPARE=OFF
endif

$(eval $(cmake-package))
