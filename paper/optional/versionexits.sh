#!/bin/bash
#################################################################
# Name:         versionexist.sh       Version:      0.3.0       #
# Created:      15.12.2021            Modified:     15.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      check the provided version agains the valid	#
#		paper versions					#
#################################################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### CHECK IF A VERSION IS PROVIDED ELSE SHOW USAGE OF SCRIPT ###
if [ "$1" == "" ]						#
 then								#
  printf "[ INFO ] no version provided... try:\n"		#
  printf "[ INFO ] ./versionexist.sh <VERSION>\n"		#
  printf "[ INFO ] No output = not valid\n"			#
  exit								#
 else								#
  VERSION=$1							#
fi								#
#################################################################

#### GET THE LATEST VERSIONS.JSON FOR COMPARISON ################################################
if [ ! -f versions.json ]									#
 then												#
  curl -s https://papermc.io/api/v2/projects/paper | jq  > versions.json                        #
fi												#
#################################################################################################

#### EXTRACT THE CORRESPONDING VERSION.JSON #####################################################
VERSION=$(jq  ".versions" versions.json | tr -d '{,"} ' | grep -o "$VERSION")			#
if [ "$VERSION" == "" ]										#
 then												#
  # VERSION NOT KNOWN BY MOJANG, NO OUTPUT WILL BE USED BY SETUP.SH AS INDICATOR		#
  exit												#
 else												#
  printf "[$GREEN INFO $NORMAL] $VERSION is a valid version!\n"					#
fi												#
#################################################################################################

#### CLEAN UP ###########
rm versions.json	#
#########################

#### EOF ####
