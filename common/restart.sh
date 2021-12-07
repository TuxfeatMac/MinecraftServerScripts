#!/bin/bash
#################################################################
# Name:         restart.sh            Version:      0.3.0       #
# Created:      01.02.2021            Modified:     05.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      restart a running MineCraftServer               #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""                               #
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
  NOW="true"            #
fi                      #
#########################

#### CHECK SETUP ########################################
if [ "$SERVER" == "" ]                                  #
 then                                                   #
  printf "[$RED EXIT $NORMAL] SERVER not set!\n"        #
  exit                                                  #
fi                                                      #
#########################################################

#### CHECK IF SERVER IS RUNNING #########################
RUN=$(screen -list | grep -o "$SERVER")                 #
if [ "$RUN" != "$SERVER" ]                              #
 then                                                   #
  printf "[ SKIP ] $SERVER in not running ...\n"        #
  exit                                                  # start it now ?
fi                                                      #
#########################################################

#### RESTART A SERVER ###################################
if [ "$NOW" == "true" ]					#
 then							#
  printf "[ INFO ] restart $SERVER...\n"        	#
  cd ~/$SERVER/scripts					#
  ./stop.sh -n						#
  ./start.sh -b						#
 else							#
  printf "[ INFO ] restart $SERVER...\n"        	#
  cd ~/$SERVER/scripts					#
  screen -S $SERVER -X stuff 'say Neustart...\n'	#
  ./stop.sh						#
  ./start.sh						#
fi							#
#########################################################
