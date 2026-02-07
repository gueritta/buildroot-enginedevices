################################################################################
#
# MICROSOFT_GSL
#
################################################################################

MICROSOFT_GSL_VERSION = 4.2.1
MICROSOFT_GSL_SITE = $(call github,microsoft,GSL,v$(MICROSOFT_GSL_VERSION))
MICROSOFT_GSL_INSTALL_STAGING = YES
MICROSOFT_GSL_INSTALL_TARGET = NO
MICROSOFT_GSL_LICENSE = MIT
MICROSOFT_GSL_LICENSE_FILES = LICENSE

$(eval $(cmake-package))
