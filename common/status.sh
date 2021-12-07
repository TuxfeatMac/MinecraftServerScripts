#!/bin/bash
#################################################################
# Name:         status.sh             Version:      0.3.0       #
# Created:      02.12.2020            Modified:     06.12.2020  #
# Author:       Joachim Traeuble                                #
# Purpose:      check status of server                          #
#################################################################

#### SERVER TO CHECK HERE #######
#################################
SERVER=""		#
#################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)	 #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)	 #
##########################

#### CHECK SETUP ########################################
#########################################################
if [ "$SERVER" == "" ]                                 	#
 then                                               	#
  printf "[$RED EXIT $NORMAL] SERVER not set!\n"	#
  exit                         	                        #
fi                                                      #
#########################################################

#### CHECK ROUTINE ######################################################
RUN=$(screen -list | grep -o "$SERVER")					#
if [ "$RUN" == "$SERVER" ]						#
 then									#
  printf "[ INFO ] [$GREEN RUNNING $NORMAL] $SERVER is up!\n"		#
 else									#
  printf "[ INFO ] [$RED STOPPED $NORMAL] $SERVER is down!\n"		#
fi									#
#########################################################################

#### EOF ####
