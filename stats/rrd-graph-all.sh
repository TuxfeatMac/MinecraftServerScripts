#!/bin/bash
#################################################################
# Name:         rrd-gen-graphs-all.sh  Version:      0.0.3      # <= early alpha
# Created:      01.04.2020             Modified:     09.12.2021 #
# Author:       Joachim Traeuble                                #
# Purpose:      generate graphs from rrd for all online servers #
#################################################################

MCUSER=""

SERVERS=$(screen -list | cut -d '.' -f 2 | cut -f 1 | cut -d ':' -f 2 | xargs)

TIMES="1h 1d 1w 1m 1y"

SPACER1="==========================================\n"

for SERVER in $SERVERS
do
 for TIME in $TIMES
 do
  HOMEDIR="/home/$MCUSER/"  # get through pwd ?
  PICDIR="$HOMEDIR$SERVER/scripts/stats/"
  PICNAME="$PICDIR$SERVER"
  RRDDIR="$HOMEDIR$SERVER/scripts/stats/"
  RRDDATA="$RRDDIR$SERVER"
  RRD="$RRDDATA-Stats.rrd"

 printf "$SPACER1"
  printf "[ INFO ] Genrating $TIME Graphs for $SERVER\n"
  if [ -f $RRD ]
   then
    rrdtool graph $PICNAME-TPS-$TIME.png --start now-$TIME --end now \
    DEF:tps=$RRD:tps:AVERAGE \
    AREA:tps#FF0000:"TPS" > /dev/null

    rrdtool graph $PICNAME-Player-$TIME.png --start now-$TIME --end now \
    DEF:player=$RRD:player:AVERAGE \
    AREA:player#AA0000:"Player" > /dev/null

    rrdtool graph $PICNAME-RAM-$TIME.png --start now-$TIME --end now \
    DEF:usedmem=$RRD:usedmem:AVERAGE \
    AREA:usedmem#111000:"Mem" > /dev/null
  else
   printf "[ SKIP ] NO RRD FOUND create a rrd with rrd-create.sh\n"
 fi
 done
printf "[ DONE ] Graphs for $SERVER are ready\n"
done

printf "$SPACER1"
printf "[ DONE ] Job completed!\n"
printf "$SPACER1"
