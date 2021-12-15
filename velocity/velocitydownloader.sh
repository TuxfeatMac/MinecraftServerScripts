#!/bin/bash
#################################################################
# Name:         velocitydownloader.sh Version:      0.0.3       #
# Created:      15.12.2021            Modified:     15.15.2021  #
# Author:       Joachim Traeuble / TuxfeatMac                   #
# Purpose:      download the velocity.jar from PaperMC based on #
#               the provided version                            #
#################################################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### GET ALL AVAIABLE VERSIONS AND EXTRACT LATEST RELEASE / SNAPSHOT ####################
curl -s https://papermc.io/api/v2/projects/velocity | jq  > versions.json		#
printf "[$GREEN DONE $NORMAL] fetched latest manifest from PaperMC\n"			#
LATEST=$(jq '.versions' versions.json | grep -v SNAPSHOT | tail -n 2 | tr -d '", ]\n')	#
LATESTSNAP=$(jq '.versions' versions.json | grep SNAPSHOT | tail -n 1 | tr -d '", ]')	#
#########################################################################################

#### CHECK IF A VERSION IS PROVIDED ELSE SHOW USAGE OF SCRIPT ###########
if [ "$1" == "" ]                                                       #
 then                                                                   #
  printf "[ INFO ] no version provided... try:\n"                       #
  printf "[ INFO ] ./serverdownload.sh <VERSION>\n"                     #
  printf "[ INFO ] latest$GREEN release $NORMAL:    $LATEST\n"          #
  printf "[ INFO ] latest$YELLOW snapshot $NORMAL:   $LATESTSNAP\n"     #
  printf "[ INFO ] assuming latest release...\n"                        #
  VERSION=$LATEST                                                       #
 else                                                                   #
  VERSION=$1                                                            #
fi                                                                      #
#########################################################################

#### GET LATEST BUILD ###########################################################################
curl -s https://papermc.io/api/v2/projects/velocity/versions/$VERSION/ | jq > $VERSION.json	#
LATESTBUILD=$(jq '.builds' $VERSION.json | tail -n 2 | tr -d ']} \n' )				#
CHECK=$(cat "$VERSION.json" | grep -o error)							#
if [ "$CHECK" != "" ]				                                              	#
 then                                                                                   	#
  printf "[$YELLOW INFO $NORMAL] $RED$VERSION$NORMAL does not exist!\n"                 	#
  printf "[ INFO ] Try: $GREEN$LATEST$NORMAL or $YELLOW$LATESTSNAP$NORMAL \n"           	#
  rm versions.json										#
  rm $VERSION.json > /dev/null 2>&1                                                          	#
  exit                                                                                  	#
fi                                                                                      	#
#################################################################################################

#### DOWNLOAD THE VELOCITY.JAR ##################################################################################################################################
printf "[ WAIT ] downloading latest velocity.jar, build $LATESTBUILD, from papermc.io...\n"									#
printf "wget https://papermc.io/api/v2/projects/velocity/versions/${VERSION}/builds/${LATESTBUILD}/downloads/velocity-${VERSION}-${LATESTBUILD}.jar "		#
wget https://papermc.io/api/v2/projects/velocity/versions/${VERSION}/builds/${LATESTBUILD}/downloads/velocity-${VERSION}-${LATESTBUILD}.jar -q --show-progress	#
printf "[$GREEN DONE $NORMAL] download finished! \n"                    											#
#################################################################################################################################################################

#### CLEAN UP ###########
rm versions.json        #
rm $VERSION.json        #
#########################

#### EOF ####
