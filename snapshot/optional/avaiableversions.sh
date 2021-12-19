# !/bin/bash
#################################################################
# Name:         versionexist.sh       Version:      0.3.0       #
# Created:      05.12.2021            Modified:     08.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      check the provided version agains the valid     #
#               mojang versions                                 #
#################################################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### DEFINE DYINAMIC SEPERATOR LINE #############################################
dynline1() {                                                                    #
if [ "$SSH_TTY" != "" ]                                                         #
 then                                                                           #
  WIDTHMAX=$(stty -a <$SSH_TTY | grep -Po '(?<=columns )\d+')                   #
 else                                                                           #
 WIDTHMAX=$(tput cols)                                                          #
fi                                                                              #
  for (( WIDTH=40; WIDTH<=$WIDTHMAX; WIDTH++ ))                                 #
   do                                                                           #
    printf '=' 		                                                        #
  done                                                                          #
}                                                                               #
#################################################################################

#### GET THE LATEST VERSIONS MANIFEST FROM MOJANG ###############################################
curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq > versions.json	#
printf "[$GREEN DONE $NORMAL] fetched latest manifest from Mojang\n"				#
#################################################################################################

#### EXTRACT VERSIONS FOR LISTING #######################################################################
LATEST=$(jq -r '.latest.release' versions.json)                                                 	#
LATESTSNAP=$(jq -r '.latest.snapshot' versions.json)                                            	#
ALLSNAP=$(jq  -r '.versions | .[] | select(.type == "snapshot" ) | .id' versions.json | xargs)		#
ALLRELEASE=$(jq  -r '.versions | .[] | select(.type == "release" ) | .id' versions.json | xargs)	#
#########################################################################################################

#### CLI OUTPUT ALL VERSIONS ####################################
printf "\n=== ALL RELEASE VERSIONS ==============" && dynline1	#
printf "\n$ALLRELEASE\n\n"					#
printf "=== ALL SNAPSHOT VERSIONS =============" && dynline1	#
printf "\n $ALLSNAP\n\n"					#
printf "=== LATEST RELEASE / SNAPSHOT VERSION =" && dynline1	#
printf "===> $LATEST / $LATESTSNAP \n"				#
#################################################################
