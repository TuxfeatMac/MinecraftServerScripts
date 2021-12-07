#!/bin/bash
#################################################################
# Name:         applyupdate.sh        Version:      0.3.0       #
# Created:      02.12.2021            Modified:     07.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      apply paper and plugin updates	                #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""                   	#
SERVERTYPE=""			#
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)	 #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)	 #
##########################

#### STATIC VARIABELS AND DIRECTORIES ###########
PLDIR=~/$SERVER/plugins/			#
UDIR=~/$SERVER/scripts/update/			#
NSDIR=~/$SERVER/scripts/update/$SERVERTYPE/	#
UPDIR=~/$SERVER/scripts/update/plugins/		#
NPDIR=~/$SERVER/scripts/update/plugins/new/	#
MPDIR=~/$SERVER/scripts/update/plugins/man/	#
#################################################

#### CHECK ADJUSTABLE VARS  #####################################
for VAR in "$SERVER" "$SERVERTYPE"                              #
 do                                                             #
  if [ "$VAR" == "" ]                                           #
   then                                                         #
    printf "[$RED EXIT $NORMAL] SERVER or VERSION not set!\n"   #
    exit                                                        #
  fi                                                            #
done                                                            #
#################################################################

#### CHECK DIRS ROUTINE #########################################################
for DIR in $PLDIR $UDIR $NSDIR $UPDIR $NPDIR $MPDIR                             #
 do                                                                             #
  if [ ! -d "$DIR" ]                                                            #
   then                                                                         #
    printf "[$RED WARN $NORMAL] $DIR not present\n"                             #
    read -t 15 -n 1 -p "[ INFO ] create it? [ y / n ] " INPUT                   #
    if [ "$INPUT" == "y" ]                                                      #
     then                                                                       #
      mkdir $DIR                                                                #
      printf "\n[$GREEN DONE $NORMAL] $DIR created!\n\n"                        #
     else                                                                       #
      printf "\n[$YELLOW SKIP $NORMAL] you may run ./pluginupdate.sh again\n"   #
      exit                                                                      #
    fi                                                                          #
  fi                                                                            #
done                                                                            #
#################################################################################

#### CHECK IF SERVER IS RUNNING #################################################################
RUN=$(screen -list | grep -o "$SERVER") 							#
if [ "$RUN" == "$SERVER" ]									#
 then												#
  printf "[$YELLOW WARN $NORMAL] $SERVER is running! shutdown $SERVER with ./stop.sh first\n"	#
  exit												#
fi												#
#################################################################################################

#### DISPLAY INFO ###############################
printf "[ INFO ] applying updates now...\n"	#
#################################################

#### REPLACE OLD SERVER JAR WITH NEW ONE ########################################
CHECK=$(ls $NSDIR)								#
if [ "$CHECK" == "" ]								#
 then										#
  printf "[ SKIP ] no $SERVERTYPE updates found run ./serverupdate.sh first\n"	#
 else										#
  rm ~/$SERVER/*.jar > /dev/null 2>&1					#
  mv $NSDIR/*.jar ~/$SERVER						#
  printf "[$GREEN DONE $NORMAL] updated Server $SERVER $VERSION\n"		#
fi										#
#################################################################################

#### SKIP PLUGINS FOR VANILLA SERVER ####
if [ $SERVERTYPE == "vanilla" ]		#
 then					#
  exit					#
fi					#
#########################################

#### UPDATING AUTOMATIC PLUGINS #########################################
UPDATE=$(ls $NPDIR)							#
if [ "$UPDATE" == "" ]							#
 then									#
  printf "[ SKIP ] no new plugins found try ./pluginupdate.sh first\n"	#
 else									#
  rm $PLDIR*.jar > /dev/null 2>&1					#
  mv $NPDIR*.jar $PLDIR							#
  printf "[$GREEN DONE $NORMAL] updated downloaded plugins\n"		#
fi									#
#########################################################################

#### UPDATING MANUAL PLUGINS ############################################################
UPDATE=$(ls $MPDIR)									#
if [ "$UPDATE" == "" ]									#
 then											#
  printf "[ SKIP ] no manual added plugins found try adding plugins to $MPDIR\n"	#
 else											#
  cp $MPDIR*.jar $PLDIR									#
  printf "[$GREEN DONE $NORMAL] updated manual plugins\n"				#
fi											#
#########################################################################################

#### EOF ####
