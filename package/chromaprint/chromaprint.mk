################################################################################
#
# CHROMAPRINT
#
################################################################################

CHROMAPRINT_VERSION = 1.6.0
CHROMAPRINT_SITE = $(call github,acoustid,chromaprint,v$(CHROMAPRINT_VERSION))
CHROMAPRINT_INSTALL_STAGING = YES
CHROMAPRINT_LICENSE = LGPL2.1,MIT
CHROMAPRINT_DEPENDENCIES = fftw-double

$(eval $(cmake-package))
