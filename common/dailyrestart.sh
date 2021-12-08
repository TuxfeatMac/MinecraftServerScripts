#!/bin/bash
#################################################################
# Name:         dailyrestart.sh       Version:      0.2.0       #
# Created:      08.12.2020            Modified:     27.12.2020  #
# Author:       Joachim Traeuble                                #
# Purpose:      update and restart a MineCraftServer            #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""                               #
#########################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### CHECK SETUP ########################################
#########################################################
if [ "$SERVER" == "" ]                                  #
 then                                                   #
  printf "[$RED EXIT $NORMAL] SERVER not set!\n"        #
  exit                                                  #
fi                                                      #
#########################################################

#### AUTO UPDATE AND RESTART ROUTINE ####################################
#########################################################################
printf "\n[ INFO ] automatically update and restart $SERVER\n"		#
cd ~/$SERVER/scripts							#
printf "\n"								#
./status.sh								#
printf "\n"								#
./serverupdate.sh							#
printf "\n"								#
./pluginupdate.sh							#
printf "\n"								#
./longstop.sh								#
printf "\n"								#
./backup.sh								#
printf "\n"								#
./applyupdate.sh							#
printf "\n"								#
./start.sh -b								#
printf "\n"								#
sleep 60								#
./status.sh								#
printf "\n[$GREEN DONE $NORMAL] everything seems to be fine!\n\n"	#
#########################################################################

#### EOF ####
