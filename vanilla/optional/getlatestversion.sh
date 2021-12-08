# !/bin/bash
#################################################################
# Name:         versionexist.sh       Version:      0.3.0       #
# Created:      05.12.2021            Modified:     08.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      get latest avaiable mincraft release version    #
#################################################################

#### GET THE LATEST VERSIONS.JSON AND OUT PUT THE LATEST RELEAS VERSION #########################
curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq > versions.json	#
LATEST=$(jq -r '.latest.release' versions.json)                                                	#
printf "$LATEST\n"										#
#################################################################################################
