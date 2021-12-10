#!/bin/bash
#################################################################
# Name:         copygraphsweb.sh	Version:     0.0.3      # <= early alpha
# Created:      10.12.2021             	Modified:    09.12.2021 #
# Author:       Joachim Traeuble                                #
# Purpose:      copy graphs from server stats dirs to www dirs	#
#################################################################

MCUSER=""

#### GET ALL RUNNING SERVERS
SERVERS=$(sudo -u $MCUSER screen -list | cut -d '.' -f 2 | cut -f 1 | cut -d ':' -f 2 | xargs)

for SERVER in $SERVERS
 do
  if [ -f $RRD ]
   then
    sudo mkdir -p /var/www/html/$SERVER
    sudo cp /home/$MCUSER/$SERVER/scripts/stats/*.png /var/www/html/$SERVER/
    printf "[ DONE ] Graphs for $SERVER are copied\n"
   else
    printf "[ SKIP] $SERVER RRD setup missing...\n"
  fi
done
