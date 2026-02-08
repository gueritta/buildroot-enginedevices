################################################################################
#
# SERD
#
################################################################################

SERD_VERSION = 0.30.12
SERD_SOURCE = serd-$(SERD_VERSION).tar.bz2
SERD_SITE = https://download.drobilla.net
SERD_INSTALL_STAGING = YES
SERD_LICENSE = ISC
SERD_LICENSE_FILES = COPYING

$(eval $(waf-package))
