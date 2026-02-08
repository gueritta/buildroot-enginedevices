################################################################################
#
# MIXXX
#
################################################################################

MIXXX_VERSION = 2.5.4
MIXXX_SITE = $(call github,mixxxdj,mixxx,$(MIXXX_VERSION))
MIXXX_LICENSE = GPL-2.0+
MIXXX_LICENSE_FILES = LICENSE
# disable symlinks to avoid "failed to create symbolic link '.../src/test' because existing path cannot be removed: Is a directory"
MIXXX_CONF_OPTS = \
	-DUSE_SYMLINKS=OFF \
	-DQT_QPA_PLATFORM=eglfs \
	-DOPTIMIZE=on \
	-DQT6=OFF \
	-DQGLES2=ON

# Instruction Set Tuning for Cortex-A17
MIXXX_CFLAGS += -march=armv7-a+idiv -mfpu=neon-vfpv4 -mfloat-abi=hard -mtune=cortex-a17
MIXXX_CXXFLAGS += -march=armv7-a+idiv -mfpu=neon-vfpv4 -mfloat-abi=hard -mtune=cortex-a17

# Dependency list put together from
# 1. https://github.com/mixxxdj/mixxx/wiki/Compiling-On-Linux#arch--derivatives
# 2. https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=mixxx-git
# 3. CMakeLists.txt shipped with mixxx
MIXXX_DEPENDENCIES = \
	chromaprint \
	flac \
	lame \
	libdjinterop \
	libdrm \
	libebur128 \
	libegl \
	libgbm \
	libgles \
	microsoft-gsl \
	libogg \
	libsndfile \
	libvorbis \
	libsoundtouch \
	portaudio \
	portmidi \
	protobuf \
	protobuf-c \
	rubberband \
	taglib \
	upower \
	qt5base \
	qt5declarative \
	qt5svg \
	qt5x11extras \
	xlib_libICE \
	xlib_libSM \
	xlib_libXaw \
	xlib_libXmu \
	xlib_libXpm \
	xlib_libXt \
	xlib_libXtst

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
MIXXX_DEPENDENCIES += fftw
endif
else
MIXXX_CONF_OPTS += -DKEYFINDER=OFF
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

ifeq ($(BR2_PACKAGE_QT5BASE_SQLITE_SYSTEM),y)
MIXXX_DEPENDENCIES += sqlite
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

define MIXXX_INSTALL_LAUNCHER
	$(INSTALL) -D -m 0755 $(MIXXX_PKGDIR)/mixxx-launcher.sh \
		$(TARGET_DIR)/usr/bin/mixxx-launcher
	$(INSTALL) -D -m 0644 $(MIXXX_PKGDIR)/kms.conf \
		$(TARGET_DIR)/etc/mixxx/kms.conf
endef

MIXXX_POST_INSTALL_TARGET_HOOKS += MIXXX_INSTALL_LAUNCHER

$(eval $(cmake-package))
