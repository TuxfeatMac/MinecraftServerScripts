#!/bin/bash
#################################################################
# Name:         stop.sh               Version:      0.3.9       #
# Created:      04.12.2020            Modified:     05.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      stop a running MineCraftServer			#
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""			#
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### SCRIPT OPTIONS #####
if [ "$1" == "-n" ]     #
 then                   #
  NOW="true"     	#
fi                      #
#########################

#### CHECK SETUP ########################################
if [ "$SERVER" == "" ]                                  #
 then                                                   #
  printf "[$RED EXIT $NORMAL] SERVER not set!\n"	#
  exit                                                  #
fi                                                      #
#########################################################

#### CHECK IF SERVER IS RUNNING #########################
RUN=$(screen -list | grep -o "$SERVER") 		#
if [ "$RUN" != "$SERVER" ]				#
 then							#
  printf "[ SKIP ] $SERVER in not running ...\n"	#
  exit							#
fi							#
#########################################################

#### SHUTDOWN RUNNING SERVER ####################################################
if [ "$NOW" == "true" ]								#
 then										#
  printf "[ INFO ] $SERVER shutdown now!\n"					#
  screen -S $SERVER -X stuff 'say Herunterfahren ...\n'				#
  screen -S $SERVER -X stuff 'stop\n'						#
 else										#
  printf "[ INFO ] $SERVER shutdown in 15s\n"					#
  screen -S $SERVER -X stuff 'say Herunterfahren in 15s\n'			#
  printf "[ INFO ] $SERVER send user info\n"					#
  screen -S $SERVER -X stuff 'say gehe in die Lobby mit /server lobby\n'	#
  sleep 12									#
  screen -S $SERVER -X stuff 'say Herunterfahren in 3s\n'			#
  printf "[ INFO ] $SERVER shutdown in 3s\n"					#
  sleep 1									#
  screen -S $SERVER -X stuff 'say Herunterfahren in 2s\n'			#
  printf "[ INFO ] $SERVER shutdown in 2s\n"					#
  sleep 1									#
  screen -S $SERVER -X stuff 'say Herunterfahren in 1s\n'			#
  printf "[ INFO ] $SERVER shutdown in 1s\n"					#
  sleep 0.5									#
  printf "[ INFO ] $SERVER shutdown now!\n"					#
  screen -S $SERVER -X stuff 'say Herunterfahren ...\n'				#
  sleep 0.5									#
  screen -S $SERVER -X stuff 'stop\n'						#
  sleep 10									#
fi										#
#################################################################################

#### CHECK IF SERVER IS DOWN ############################################
RUN=$(screen -list | grep -o "$SERVER");				#
while [ "$RUN" != "" ]							#
 do									#
  RUN=$(screen -list | grep -o "$SERVER");				#
  printf "[$YELLOW INFO $NORMAL] $SERVER is still running ...\n";	#
  sleep 6;								#
 done									#
printf "[$GREEN DONE $NORMAL] $SERVER is down!\n"			#
#########################################################################

#### EOF ####
