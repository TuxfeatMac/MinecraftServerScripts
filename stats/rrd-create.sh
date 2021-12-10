#!/bin/bash
#################################################################
# Name:         rrd-createdatabase.sh  Version:      0.0.3      # <= early alpha
# Created:      01.12.2020             Modified:     06.12.2021 #
# Author:       Joachim Traeuble                                #
# Purpose:      create a rrdb for a server			#
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
SERVER=""                               #
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#rm ~/$SERVER/scripts/stats/$SERVER-Stats.rrd > /dev/null 2>&1 # needed for manual overide

#### CREAT DIR FOR STATS ################
mkdir -p ~/$SERVER/scripts/stats	#
#########################################

#### CREATE THE RRD #####################################################
rrdtool create ~/$SERVER/scripts/stats/$SERVER-Stats.rrd --step 60 \
DS:tps:GAUGE:120:0:25 \
DS:player:GAUGE:120:0:128 \
DS:usedmem:GAUGE:120:0:8192 \
RRA:AVERAGE:0.5:1:2y \
################### #####################################################

#### GET SIZE PRINT SUCCESS MESSAGE #############################################################
SIZE=$(du -h ~/$SERVER/scripts/stats/$SERVER-Stats.rrd | cut -f 1)				#
printf "[$GREEN DONE $NORMAL] $SERVER - Round Robin Database created! - Size: $SIZE\n"		#
#################################################################################################
