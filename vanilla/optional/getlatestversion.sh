#!/bin/bash

#### GET THE LATEST VERSIONS.JSON #######################################################################
curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq > versions.json      	#
LATEST=$(jq -r '.latest.release' versions.json)                                                 	#
LATESTSNAP=$(jq -r '.latest.snapshot' versions.json)                                            	#
ALLSNAP=$(jq  -r '.versions | .[] | select(.type == "snapshot" ) | .id' versions.json | xargs)		#
ALLRELEASE=$(jq  -r '.versions | .[] | select(.type == "release" ) | .id' versions.json | xargs)	#
#########################################################################################################
printf "$LATEST\n"
