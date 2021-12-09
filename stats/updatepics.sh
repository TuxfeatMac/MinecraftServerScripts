#!/bin/bash
#################################################################
# Name:         rrd-gen-graphs-all.sh  Version:      0.0.3      # <= early alpha
# Created:      01.04.2020             Modified:     09.12.2021 #
# Author:       Joachim Traeuble                                #
# Purpose:      copy graphs from server stats dir to www	#
#################################################################

SERVERS=$(screen -list | cut -d '.' -f 2 | cut -f 1 | cut -d ':' -f 2 | xargs)

TIMES="1h 1d 1w 1m 1y"
SPACER1="==========================================\n"

# check iff rrd exist else exit error

for SERVER in $SERVERS
 do
  sudo mkdir -p /var/www/html/$SERVER
  sudo cp ~/$SERVER/scripts/stats/*.png /var/www/html/$SERVER/
  printf "[ DONE ] Graphs for $SERVER are copied\n"
done
