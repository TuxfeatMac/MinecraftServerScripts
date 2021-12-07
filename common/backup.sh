#!/bin/bash
#################################################################
# Name:         backup.sh             Version:      0.3.0       #
# Created:      08.12.2020            Modified:     05.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      do a full backup of a MineCraftServer (copy)    #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
SERVER=""                               #
MAXBACKUPSIZE="16"	# in GB		#
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### STATIC VARIABELS AND DIRECTORIES ###
SDIR=~/$SERVER				#
BDIR=~/backup				#
BKDIR=~/backup/$SERVER		   	#
SSIZE=$(du -sh $SDIR)			#
SSIZE=$(echo ${SSIZE%%/*})		#
TIMESTAMP=$(date +%H_%M-%d_%m_%y)	#
#########################################

#### CHECK SETUP ########################################################
for VAR in "$SERVER" "$TIMESTAMP" "$SSIZE" "MAXBACKUPSIZE"		#
 do                                                     		#
  if [ "$VAR" == "" ]                                   		#
   then                                                 		#
    printf "[$RED EXIT $NORMAL] SERVER or MAXBACKUPSIZE not set!\n"	#
    exit                                                		#
  fi                                                    		#
done                                                    		#
#########################################################################

#### CHECK IF SERVER IS RUNNING IF SO ASK TO SHWO CONSOLE ###############
RUN=$(screen -list | grep -o "$SERVER")                                 #
if [ "$RUN" == "$SERVER" ]                                              #
 then                                                                   #
  printf "[$RED WARN $NORMAL] $SERVER is running!\n" 		 	#
  exit									#
fi									#
#########################################################################

#### CHECK DIRS FOLDER OR CREATE IT #####################################
for DIR in $BDIR $BKDIR	                                                #
 do                                                                     #
  if [ ! -d "$DIR" ]                                                    #
   then                                                                 #
    printf "[$RED WARN $NORMAL] $DIR not present\n"                     #
    read -t 15 -n 1 -p "[ INFO ] create it? [ y / n ] " INPUT           #
    if [ "$INPUT" == "y" ]                                              #
     then                                                               #
      mkdir $DIR                                                        #
      printf "\n[$GREEN DONE $NORMAL] $DIR created!\n\n"                #
     else                                                               #
      printf "\n[$YELLOW SKIP $NORMAL] you may run ./backup.sh again\n"	#
      exit                                                              #
    fi                                                                  #
  fi                                                                    #
done                                                                    #
#########################################################################

#### GET TOTAL BACKUPS SIZE AND CONVERT #########
printf "[ INFO ] fetching backup infos...\n"    #
BSIZE=$(du -sh $BDIR/)				#
BSIZE=$(echo ${BSIZE%%/*})			#
MBSIZE=$(du -s $BDIR/)				#
MBSIZE=$(echo ${MBSIZE%%/*})			#
BMAXBACKUPSIZE=$(($MAXBACKUPSIZE*1024*1024))	#
#################################################

#### CHECK BACKUP FOLDER SIZE LIMIT #####################################################
if [ "$MBSIZE" -gt "$BMAXBACKUPSIZE" ]							#
 then											#
  printf "[$YELLOW WARN $NORMAL] No Space Left! Limit of $MAXBACKUPSIZE GB exceeded!\n"	#
  printf "[ INFO ] delete old backups in $BDIR\n"					#
  printf "[ INFO ] or incrase MAXBACKUPSIZE in ./backup.sh\n"				#
  printf "[$RED EXIT $NORMAL] no backup made! \n"					#
  exit											#
fi											#
#########################################################################################

#### CREATE FOLDER WITH TIMESTAMP #######################
printf "[ INFO ] creating new backup...\n"		#
printf "[ INFO ] $SERVER - $TIMESTAMP - $SSIZE\n"	#
cd $BKDIR                                     		#
mkdir $TIMESTAMP                              		#
cd $TIMESTAMP         					#
#########################################################

#### BACKUP #####################
cp -r $SDIR/* $BKDIR/$TIMESTAMP	#
#################################

### GETING NEW BACKUP DIR SIZE ##
BSIZE=$(du -sh $BDIR/)		#
BSIZE=$(echo ${BSIZE%%/*})	#
#################################

#### BACKUP INFOS ###############################################################################
printf "[$GREEN DONE $NORMAL] backup complete! backup folder - $BSIZE/"$MAXBACKUPSIZE".0G\n"	#
#################################################################################################

#### EOF ####
