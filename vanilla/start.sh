#!/bin/bash
#################################################################
# Name:         start.sh              Version:      0.3.0       #
# Created:      02.12.2020            Modified:     27.12.2020  #
# Author:       Joachim Traeuble                                #
# Purpose:      start a MineCraftServer                         #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""			#
VERSION=""			#
RAM=""				#
#########################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### SCRIPT OPTIONS #####
#########################
if [ "$1" == "-b" ]	#
 then			#
  BACKGROUND="true"	#
fi			#
#########################

#### CHECK SETUP ########################################################
#########################################################################
for VAR in "$SERVER" "$VERSION" "$RAM"					#
 do									#
  if [ "$VAR" == "" ]                           		        #
   then                                                 		#
    printf "[$RED EXIT $NORMAL] SERVER, VERSION or RAM not set!\n"      #
    exit                                                		#
  fi                                                   		 	#
done									#
#########################################################################

#### CHECK IF SERVER IS RUNNING IF SO ASK TO SHWO CONSOLE ###############
#########################################################################
RUN=$(screen -list | grep -o "$SERVER")					#
if [ "$RUN" == "$SERVER" ]              		              	#
 then                          		                           	#
  printf "[ SKIP ] [$GREEN RUNNING $NORMAL] $SERVER is already up!\n"	#
  read -t 6 -n 1 -p "[  IN  ] [  y / n  ] show console? : " INPUT	#
  printf "\n"								#
   if [ "$INPUT" == "y" ]						#
   then									#
    screen -R $SERVER							#
   fi									#
  exit									#
fi                                                           		#
#########################################################################

#### START SERVER #######################################################################
#########################################################################################
printf "[ INFO ] [$YELLOW  START  $NORMAL] starting $SERVER with $RAM Ram now...\n"	#
cd ~/$SERVER/                                              				#
screen -mdS $SERVER java -Xmx$RAM -Xms$RAM -jar vanilla-$VERSION.jar --nogui	 	#
#########################################################################################

#### FORCED BACKGROUND START ####
#################################
if [ "$BACKGROUND" == "true" ]	#
 then				#
  exit				#
fi				#
#################################

#### WATCH STARTUP ######################################################
#########################################################################
read -t 6 -n 1 -p "[  IN  ] [  y / n  ] watch startup? : " INPUT	#
printf "\n"								#
if [ "$INPUT" == "y" ]							#
 then									#
  screen -R $SERVER							#
 else									#
  printf "[$GREEN DONE $NORMAL] $SERVER is running in background\n"	#
fi									#
#########################################################################

#### EOF ####
