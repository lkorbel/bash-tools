#!/bin/bash

#
# GOOGLE MAPS - GETS LOCATION
# Łukasz Korbel @ 2025
# lkorbel@tuta.io
#
# Extract location data from google maps short links.
# Usage:
# google-maps-get-location URL
# returns: location data
#

require curl grep sed || exit 1

curl -i ${1?} | grep "location" | sed "s/.*!8m2!3d\([0-9\.]*\)!4d\([0-9\.]*\).*/location: \1,\2/"
