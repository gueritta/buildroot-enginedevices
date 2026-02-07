################################################################################
#
# PORTMIDI
#
################################################################################

PORTMIDI_VERSION = 2.0.7
PORTMIDI_SOURCE = portmidi-$(PORTMIDI_VERSION).tar.gz
PORTMIDI_SITE = $(call github,PortMidi,portmidi,v$(PORTMIDI_VERSION))
PORTMIDI_INSTALL_STAGING = YES
PORTMIDI_LICENSE = Expat

$(eval $(cmake-package))
