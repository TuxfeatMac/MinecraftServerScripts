#!/bin/bash
#################################################################
# Name:         serverdownloader.sh   Version:      0.3.0       #
# Created:      21.02.2021            Modified:     05.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      download the server.jar from Mojang based on	#
#		the provided version                         	#
#################################################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### GET THE LATEST VERSIONS.JSON ###############################################################
curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq > versions.json	#
printf "[$GREEN DONE $NORMAL] fetched latest manifest from Mojang\n"				#
LATEST=$(jq -r '.latest.release' versions.json)							#
LATESTSNAP=$(jq -r '.latest.snapshot' versions.json)						#
#################################################################################################

#### CHECK IF A VERSION IS PROVIDED ELSE SHOW USAGE OF SCRIPT ###
if [ "$1" == "" ]						#
 then								#
  printf "[ INFO ] no version provided... try:\n"		#
  printf "[ INFO ] ./serverdownload.sh <VERSION>\n"		#
  printf "[ INFO ] latest$GREEN release $NORMAL:    $LATEST\n"		#
  printf "[ INFO ] latest$YELLOW snapshot $NORMAL:   $LATESTSNAP\n"		#
  printf "[ INFO ] assuming latest release...\n"		#
  VERSION=$LATEST						#
 else								#
  VERSION=$1							#
fi								#
#################################################################

#### EXTRACT THE CORRESPONDING VERSION.JSON #############################################
VERSIONURL=$(jq -r ".versions | .[] | select(.id==\"$VERSION\") | .url" versions.json)	#
if [ "$VERSIONURL" == "" ]								#
 then											#
  printf "[$YELLOW INFO $NORMAL] $RED$VERSION$NORMAL does not exist!\n"			#
  printf "[ INFO ] Try: $GREEN$LATEST$NORMAL or $YELLOW$LATESTSNAP$NORMAL \n"		#
  rm versions.json									#
  exit											#
fi											#
#########################################################################################

#### GET THE CORRESPONDING VERSION.JSON #########
curl -s $VERSIONURL | jq > $VERSION.json	#
#################################################

#### EXTRACT THE DOWNLOAD URL ###################################################
SERVERURL=$(jq -r '.downloads.server.url' $VERSION.json)			#
printf "[$GREEN DONE $NORMAL] fetched latest download url from Mojang\n"	#
#################################################################################

#### DOWNLOAD THE SERVER.JAR ############################################
printf "[ WAIT ] downloading latest server.jar from Mojang...\n"	#
wget -O vanilla-$VERSION.jar $SERVERURL -q --show-progress 		#
printf "[$GREEN DONE $NORMAL] download finished! \n"			#
#########################################################################

#### CLEAN UP ###########
rm versions.json	#
rm $VERSION.json	#
#########################

#### EOF ####
