################################################################################
#
# ms-gsl
#
################################################################################

MS_GSL_VERSION = 4.1.0
MS_GSL_SITE = $(call github,microsoft,GSL,v$(MS_GSL_VERSION))
MS_GSL_LICENSE = MIT
MS_GSL_LICENSE_FILES = LICENSE
MS_GSL_INSTALL_STAGING = YES
MS_GSL_INSTALL_TARGET = NO

# Header-only library - just copy includes
define MS_GSL_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/gsl
	cp -r $(@D)/include/gsl/* $(STAGING_DIR)/usr/include/gsl/
endef

$(eval $(generic-package))
