################################################################################
#
# PORTMIDI
#
################################################################################

PORTMIDI_VERSION = 2.0.7
PORTMIDI_SITE = $(call github,PortMidi,portmidi,v$(PORTMIDI_VERSION))
PORTMIDI_INSTALL_STAGING = YES
PORTMIDI_LICENSE = Expat

$(eval $(cmake-package))
