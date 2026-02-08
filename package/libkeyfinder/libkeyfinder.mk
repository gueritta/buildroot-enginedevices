################################################################################
#
# LIBKEYFINDER
#
################################################################################

LIBKEYFINDER_VERSION = 2.2.8
LIBKEYFINDER_SITE = $(call github,mixxxdj,libkeyfinder,v$(LIBKEYFINDER_VERSION))
LIBKEYFINDER_INSTALL_STAGING = YES
LIBKEYFINDER_LICENSE = GPL-3.0+
LIBKEYFINDER_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_FFTW_DOUBLE),y)
LIBKEYFINDER_DEPENDENCIES += fftw
endif

$(eval $(cmake-package))
