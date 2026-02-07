################################################################################
#
# RUBBERBAND
#
################################################################################

RUBBERBAND_VERSION = 4.0.0
RUBBERBAND_SITE = $(call github,breakfastquay,rubberband,v$(RUBBERBAND_VERSION))
RUBBERBAND_INSTALL_STAGING = YES
RUBBERBAND_LICENSE = GPLv2

ifeq ($(BR2_PACKAGE_FFTW_DOUBLE),y)
RUBBERBAND_DEPENDENCIES += fftw-double
endif

ifeq ($(BR2_PACKAGE_KISSFFT),y)
RUBBERBAND_DEPENDENCIES += kissfft
endif

ifeq ($(BR2_PACKAGE_LADSPA),y)
RUBBERBAND_DEPENDENCIES += ladspa
endif

ifeq ($(BR2_PACKAGE_LIBSAMPLERATE),y)
RUBBERBAND_DEPENDENCIES += libsamplerate
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
RUBBERBAND_DEPENDENCIES += libsndfile
endif

ifeq ($(BR2_PACKAGE_LV2),y)
RUBBERBAND_DEPENDENCIES += lv2
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
RUBBERBAND_DEPENDENCIES += speex
endif

ifeq ($(BR2_PACKAGE_VAMP_SDK),y)
RUBBERBAND_DEPENDENCIES += vamp-sdk
endif

$(eval $(meson-package))
