#!/bin/bash
#################################################################
# Name:         serverupdate.sh       Version:      0.2.9       #
# Created:      02.12.2020            Modified:     10.12.2020  #
# Author:       Joachim Traeuble                                #
# Purpose:      fetching the latest paper server 	        #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""                        	#
VERSION=""				#
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### STATIC VARIABELS AND DIRECTORIES ###########
UDIR=~/$SERVER/scripts/update/			#
USDIR=~/$SERVER/scripts/update/paper/		#
#################################################

#### CHECK SETUP ################################################
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
RUN=$(screen -list | grep -o "$SERVER")                 			#
if [ "$RUN" == "$SERVER" ]                              			#
 then                                                   			#
  printf "[ INFO ] $SERVER is running... also informing users...\n"		#
  screen -S $SERVER -X stuff 'say [Info] downloading Server updates...\n'	#
fi                                                     				#
#################################################################################

#### GETTING PAPER SERVER UPDATES READY TO INSTALL ######################################################
cd $USDIR												#
rm *.jar > /dev/null 2>&1										#
LATESTBUILD=$(curl -s https://papermc.io/api/v2/projects/paper/versions/$VERSION/ | jq '.[]' | tail -n 2 | head -n 1 | xargs) ## not perfect but works, better jq aerguments avaible allso check first  like on vanilla ? or even move to seperate "downloader ?"
printf "[ INFO ] downloading latest PaperServer $VERSION ...\n"						#
wget https://papermc.io/api/v2/projects/paper/versions/$VERSION/builds/$LATESTBUILD/downloads/paper-$VERSION-$LATESTBUILD.jar -q --show-progress
printf "[$GREEN DONE $NORMAL] update ready apply with ./applyupdate.sh\n"				#
#########################################################################################################

#### CHECK IF SERVER IS RUNNING IF SO INFORM USERS ON SERVER ############
if [ "$RUN" == "$SERVER" ]                                              #
 then                                                                   #
  screen -S $SERVER -X stuff 'say [Info] Download erfolgreich!\n' 	#
fi                                                                      #
#########################################################################

#### EOF ####
