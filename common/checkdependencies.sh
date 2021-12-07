# !/bin/bash
#################################################################
# Name:      checkdependencies.sh         Version:      0.3.0   #
# Created:   05.12.2021		     Modified:     18.04.2021  	#
# Author:    Joachim Traeuble                                	#
# Purpose:   check if all nessesary dependencies are installed	#
#            to run the scripts and server.			#
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
VERSION=""                      #
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### STATIC VARIABELS ###################################################
SPACER_1="=========================================================\n"  #
#########################################################################

#### CHECK TOOLS ################################################################################
printf "[ INFO ] checking dependencies... \n"							#
PKGS='screen curl jq unzip rrdtool'								#
for PKG in $PKGS										#
 do												#
  INSTALLED=$(command -v $PKG | cut -d "/" -f 4)                                     		#
  if [ "$INSTALLED" == "" ]                                                               	#
   then												#
    printf "[$YELLOW WARN $NORMAL] to run this server and scripts you need the $PKG pkg!\n"	#
    printf "[ INFO ] installing $PKG via apt\n"							#
    printf "$SPACER_1"										#
    sudo apt -y install $PKG									#
    printf "$SPACER_1"										#
    printf "[$GREEN DONE $NORMAL] installed $PKG\n"						#
   else                                                         				#
    printf "[  OK  ] $PKG\n"									#
  fi												#
done                                                                                      	#
#################################################################################################

#### CHECK JQ VERSION ################################################################### scripts wont work with lower jq version
JQVERSION=$(jq --version | cut -d '-' -f 2)						#
if [ "$JQVERSION" == "1.6" ]								#
 then											#
  printf "[  OK  ] jq\t> $JQVERSION\n"							#
 else											#
  printf "[ INFO ] Your jq version is -> $JQVERSION\n"					#
  printf "[$RED WARN $NORMAL] jq version 1.6 or higher is required!\n"			#
  printf "[$RED EXIT $NORMAL] manual intervention is required!\n"			#
  exit											#
fi											#
#########################################################################################

#### CHECK JAVA VERSION ######################################################################### match server veersion with java version
JAVA=$(command -v java | cut -d "/" -f 4)                                                     	#
if [ "$JAVA" == "" ]                                                                  		#
 then                                                                                         	#
  printf "\n[$YELLOW WARN $NORMAL] to run this server and scripts you need java !\n"		#
  printf "\n[ INFO ] installing default java jdk headless via apt\n"                            #
  sudo apt install -y default-jdk-headless							#
  else												#
   JVER=$(java -version 2>&1 | grep version | cut -d " " -f 3 | tr -d '"')			#
    case $VERSION in										#
    '1.18')											# add the other popular versions....
     if [ "$JVER" != "17" ]									#
      then											#
       printf "[ INFO ] java version $JVER found.\n"						#
       printf "[$YELLOW WARN $NORMAL] to run this server need java version < 17!\n"		#
       printf "[ INFO ] installing java 17 via apt\n\n"                                       	#
       printf "$SPACER_1"									#
       sudo apt install -y openjdk-17-jdk-headless						#
       printf "$SPACER_1"									#
      else											#
       printf "[  OK  ] $JAVA\t> $JVER\n"                                            		#
     fi;;											#
    *)												#
     printf "[$YELLOW WARN $NORMAL] java version for miencraft $VERSION undefined!\n"		#
     printf "[$YELLOW WARN $NORMAL] unable to check against miencraft version...\n"		#
     printf "[$YELLOW WARN $NORMAL]$RED install correct java version for minecraft version manually!$NORMAL\n"		#
     exit;;                                             					#
   esac												#
fi												#
#################################################################################################

#########################################################################################
printf "[$GREEN DONE $NORMAL] all dependencies are installed!\n"			#

#### EOF ####
