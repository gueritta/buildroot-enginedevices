################################################################################
#
# QTKEYCHAIN
#
################################################################################

QTKEYCHAIN_VERSION = 0.15.0
QTKEYCHAIN_SITE = $(call github,frankosterfeld,qtkeychain,v$(QTKEYCHAIN_VERSION))
QTKEYCHAIN_INSTALL_STAGING = YES
QTKEYCHAIN_LICENSE = ModifiedBSD
QTKEYCHAIN_DEPENDENCIES = libsecret qt5base qt5tools

$(eval $(cmake-package))
