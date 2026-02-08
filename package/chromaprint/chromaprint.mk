################################################################################
#
# CHROMAPRINT
#
################################################################################

CHROMAPRINT_VERSION = 1.6.0
CHROMAPRINT_SITE = $(call github,acoustid,chromaprint,v$(CHROMAPRINT_VERSION))
CHROMAPRINT_INSTALL_STAGING = YES
CHROMAPRINT_LICENSE = LGPL-2.1+ and MIT
CHROMAPRINT_LICENSE_FILES = LICENSE.md
CHROMAPRINT_DEPENDENCIES = fftw

$(eval $(cmake-package))
