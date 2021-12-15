# !/bin/bash
#################################################################
# Name:         versionexist.sh       Version:      0.3.0       #
# Created:      05.12.2021            Modified:     08.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      get latest avaiable paper release version       #
#################################################################

#### GET THE LATEST VERSIONS.JSON AND OUT PUT THE LATEST RELEAS VERSION #########################
curl -s https://papermc.io/api/v2/projects/paper | jq  > versions.json				#
LATEST=$(jq -r '.versions' versions.json | tail -n 3  versions.json | head -n 1 | tr -d '" ')   #
printf "$LATEST\n"										#
#################################################################################################

#### EOF ####
