#!/bin/bash
#################################################################
# Name:         longstop.sh           Version:      0.2.2       #
# Created:      08.12.2020            Modified:     12.12.2020  #
# Author:       Joachim Traeuble                                #
# Purpose:      stop a running MineCraftServer within 5 Min     #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""				#
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
  printf "[$RED EXIT $NORMAL] SERVER not set!\n"	#
  exit                                                  #
fi                                                      #
#########################################################

#### CHECK IF SERVER IS RUNNING #########################
#########################################################
RUN=$(screen -list | grep -o "$SERVER") 		#
if [ "$RUN" != "$SERVER" ]				#
 then							#
  printf "[ SKIP ] $SERVER in not running ...\n"	#
  exit							#
fi							#
#########################################################

#### SHUTDOWN RUNNING SERVER ####################################################
#################################################################################
screen -S $SERVER -X stuff 'say [Info] Neustart in 5 Minuten\n'			#
printf "[ INFO ] $SERVER shutdown in 5Min\n"					#
sleep 60									#
screen -S $SERVER -X stuff 'say [Info] Neustart in 4 Minuten\n'			#
printf "[ INFO ] $SERVER shutdown in 4Min\n"					#
sleep 60									#
screen -S $SERVER -X stuff 'say [Info] Neustart in 3 Minuten\n'			#
printf "[ INFO ] $SERVER shutdown in 3Min\n"					#
sleep 60									#
screen -S $SERVER -X stuff 'say [Info] Neustart in 2 Minuten\n'			#
printf "[ INFO ] $SERVER shutdown in 2Min\n"					#
sleep 60									#
screen -S $SERVER -X stuff 'say [Info] Neustart in 1 Minute\n'			#
printf "[ INFO ] $SERVER shutdown in 1Min\n"					#
sleep 15									#
screen -S $SERVER -X stuff 'say [Info] der Neustart dauert ca. 4 Minuten\n'	#
sleep 15									#
printf "[ INFO ] $SERVER shutdown in 30Sec\n"					#
screen -S $SERVER -X stuff 'say [Info] Neustart in 30 Sekunden\n'		#
#screen -S $SERVER -X stuff 'say [Info] gehe in die Lobby mit /server lobby\n'	#
sleep 15									#
printf "[ INFO ] $SERVER shutdown in 15s\n"					#
screen -S $SERVER -X stuff 'say [Info] Neustart in 15s\n'			#
#screen -S $SERVER -X stuff 'say [Info] gehe in die Lobby mit /server lobby\n'	#
sleep 12									#
screen -S $SERVER -X stuff 'say [Info] Neustart in 3s\n'			#
printf "[ INFO ] $SERVER shutdown in 3s\n"					#
sleep 1										#
screen -S $SERVER -X stuff 'say [Info] Neustart in 2s\n'			#
printf "[ INFO ] $SERVER shutdown in 2s\n"					#
sleep 1										#
screen -S $SERVER -X stuff 'say [Info] Neustart in 1s\n'			#
printf "[ INFO ] $SERVER shutdown in 1s\n"					#
sleep 0.5									#
printf "[ INFO ] $SERVER shutdown now!\n"					#
screen -S $SERVER -X stuff 'say [Info] Neustart ...\n'				#
# screen -S Waterfall -X stuff 'send $SERVER lobby\n'				# Velocity? autosend? Lobby Message
sleep 0.5									#
screen -S $SERVER -X stuff 'stop\n'						#
sleep 10									#
#################################################################################

#### CHECK IF SERVER IS DOWN ############################################
#########################################################################
RUN=$(screen -list | grep -o "$SERVER");				#
while [ "$RUN" != "" ]							#
 do									#
  RUN=$(screen -list | grep -o "$SERVER");				#
  printf "[$YELLOW INFO $NORMAL] $SERVER is still running ...\n";	#
  sleep 10;								#
 done									#
printf "[$GREEN DONE $NORMAL] $SERVER is down!\n"			#
#########################################################################

#### EOF ####
