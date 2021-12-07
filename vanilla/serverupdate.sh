#!/bin/bash
#################################################################
# Name:         serverupdate.sh       Version:      0.3.0       #
# Created:      05.12.2021            Modified:     05.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      fetching the latest paper server 	        #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""                        	#
VERSION=""				#
#########################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### STATIC VARIABELS AND DIRECTORIES ###########
#################################################
UDIR=~/$SERVER/scripts/update/			#
USDIR=~/$SERVER/scripts/update/vanilla/		#
#################################################

#### CHECK SETUP ################################################
#################################################################
for VAR in "$SERVER" "$VERSION"					#
 do								#
  if [ "$VAR" == "" ]                                  		#
   then 	                                 	 	#
    printf "[$RED EXIT $NORMAL] SERVER or VERSION not set!\n"	#
    exit         	                                	#
  fi                    	                        	#
done								#
#################################################################

#### CHECK DIRS FOLDER OR CREATE IT #############################################
#################################################################################
for DIR in $UDIR $USDIR								#
 do										#
  if [ ! -d "$DIR" ]                                                            #
   then                                                                         #
    printf "[$RED WARN $NORMAL] $DIR not present\n"                             #
    read -t 15 -n 1 -p "[ INFO ] create it? [ y / n ] " INPUT                   #
    if [ "$INPUT" == "y" ]                                                      #
     then                                                                       #
      mkdir $DIR                                                                #
      printf "\n[$GREEN DONE $NORMAL] $DIR created!\n\n"                        #
     else                                                                       #
      printf "\n[$YELLOW SKIP $NORMAL] you may run ./serverupdate.sh again\n"	#
      exit                                                                      #
    fi                                                                          #
  fi                                                                            #
done										#
#################################################################################

#### CHECK IF SERVER IS RUNNING IF SO INFORM USERS ON SERVER ####################
#################################################################################
RUN=$(screen -list | grep -o "$SERVER")                 			#
if [ "$RUN" == "$SERVER" ]                              			#
 then                                                   			#
  printf "[ INFO ] $SERVER is running... also informing users...\n"		#
  screen -S $SERVER -X stuff 'say [Info] downloading Server updates...\n'	#
fi                                                     				#
#################################################################################


### Quick Fix without applyupdates.sh # maybe check for new versions
./serverdownloader.sh $VERSION
mv vanilla-*.jar ~/$SERVER/


#### CHECK IF SERVER IS RUNNING IF SO INFORM USERS ON SERVER ############
#########################################################################
if [ "$RUN" == "$SERVER" ]                                              #
 then                                                                   #
  screen -S $SERVER -X stuff 'say [Info] Download erfolgreich!\n' 	#
fi                                                                      #
#########################################################################

#### EOF ####
