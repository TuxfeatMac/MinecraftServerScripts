#!/bin/bash
#################################################################
# Name:         serverstats.sh        Version:      0.0.3       # <= early alpha !
# Created:      09.12.2021            Modified:     09.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      show stats for online servers cli & update rrd's#
#################################################################

#### SET SOME COLOURS ####
BLACK=$(tput setaf 0)	 #
RED=$(tput setaf 1)	 #
GREEN=$(tput setaf 2)	 #
YELLOW=$(tput setaf 3)	 #
BLUE=$(tput setaf 4)	 #
MAGENTA=$(tput setaf 5)	 #
CYAN=$(tput setaf 6)	 #
WHITE=$(tput setaf 7)	 #
NORMAL=$(tput sgr0)	 #
##########################

#### SET SOME SPACERS ####
SPACER_0='-'		 #
SPACER_1='='		 #
SPACER_2='=============================================================================================\n'
##########################

#### SET SERVERSNAMES GET COUNT AND NAMES ###############################
SERVERS=$(screen -list | cut -d '.' -f 2 | cut -f 1 | cut -d ':' -f 2 )	#
SERVERSLINE=$(echo $SERVERS | xargs)					#
SERVERCOUNT=$(echo $SERVERS | wc -w)					#
if [ "$SERVERCOUNT" == "" ]
 then
  printf "[ EXIT ] SART A SERVER WITH SCRIPT/SCREEN \n"
  exit
fi									#
####clear ?

#### DEFINE DYINAMIC SEPERATOR LINE #############################################
if [ "$SSH_TTY" != "" ]                                                         #
 then                                                                           #
  WIDTHMAX=$(stty -a <$SSH_TTY | grep -Po '(?<=columns )\d+')                   #
 else                                                                           #
 WIDTHMAX=$(tput cols)                                                          #
fi                                                                              #

#### PRINT DYNAMIC HEADER1 ######################################
#WIDTHMAX=$(stty -a <$SSH_TTY | grep -Po '(?<=columns )\d+')	#
for (( WIDTH=1; WIDTH<=$WIDTHMAX; WIDTH++ ))			#
 do								#
  printf "$SPACER_1"						#
done								#
#################################################################
printf "[ UP ] $SERVERSLINE \n"
#### PRINT DYNAMIC HEADER2 ######################################
for (( WIDTH=1; WIDTH<=$WIDTHMAX; WIDTH++ ))			#
 do								#
  printf "$SPACER_1"						#
done								#
#################################################################
printf "\n"

#########################################################################
#### FOR EACH FOUND SERVER FETCH STATISTICS PRINT THEM PRETTY AND SAVE SOME STATS IN RRD ####
for (( SERVERNR=1; SERVERNR<=$SERVERCOUNT; SERVERNR++ ))
 do
  SERVER=$(echo "$SERVERSLINE" | cut -d ' ' -f $SERVERNR)
  if [ -f ~/$SERVER/server.properties ] ## Filters Screens Non related to Minecraft.. Allso Proxy.. ##
   then
    if [ -f ~/$SERVER/plugins/EssentialsX-*.jar ] # is spigot / bukkit / paper with essentials preffered!
     then
      screen -S $SERVER -X stuff 'gc\n'
      sleep 1
      TPS=$(tail -n 10 ~/$SERVER/logs/latest.log | grep -m1 TPS | cut -d '=' -f 2 | tr -d ' ')
      #UPTIME not really intressting
      UPTIME=$(tail -n 10 ~/$SERVER/logs/latest.log | grep -m1 Uptime | cut -d ':' -f 5)
      MAXMEM=$(tail -n 10 ~/$SERVER/logs/latest.log | grep -m1 Maximum | cut -d ':' -f 5 | cut -d '.' -f 1 | cut -d 'M' -f 1 | tr -d ',' | tr -d ' ')
      if [ "$MAXMEM" == "" ]
       then
        MAXMEM="0"
      fi
      FREEMEM=$(tail -n 10 ~/$SERVER/logs/latest.log | grep -m1 Free | cut -d ':' -f 5 | cut -d '.' -f 1 | cut -d 'M' -f 1 | tr -d ',' | tr -d ' ')
      if [ "$FREEMEM" == "" ]
       then
        FREEMEM="0"
      fi
      USEDMEM=$(("$MAXMEM"-"$FREEMEM" ))
      PORT=$(grep server-port ~/$SERVER/server.properties | cut -d '=' -f 2)
     #
     else # Vanilla (1.16.5 tested) Proxy or Unkowen
      if [ -f ~/$SERVER/server.properties ]
       then # Minecrfat Vanill or Unknown
        screen -S $SERVER -X stuff 'debug start\n'
        sleep 5
        screen -S $SERVER -X stuff 'debug stop\n'
        sleep 1
        TPS=$(tail -n 2 ~/$SERVER/logs/latest.log | grep ticks | cut -d '(' -f 2 | cut -d ' ' -f 1)
        if [ "$TPS" == "" ]
         then
          TPS="1"
        fi
        UPTIME="vanilla/unknown" #### "0"
        MAXMEM=' ? ' #### "0" set 0 again rrd update? .. get from script?####
        FREEMEM=' ? '
        USEDMEM="0"
        #rm -r ~/$SERVER/debug # CleanUp
        PORT=$(grep server-port ~/$SERVER/server.properties | cut -d '=' -f 2)
       else #Proxy no server.properties
        TPS="20" #Proxy rrd needed
        UPTIME="Proxy or unknowen" #### "0" #### ($uptime -p)
        MAXMEM='?' #### get from script
        FREEMEM='?'
        USEDMEM='0'
        PORT='0'
#        PORT=$(grep server-port ~/$SERVER/server.properties | cut -d '=' -f 2)
      fi
    fi
    # FETCH DATA FROM JSON'S
    if [ -f ~/$SERVER/usercache.json ] ## Filters Proxy
     then
      USERCOUNT=$(jq length ~/$SERVER/usercache.json)
     else
      USERCOUNT='0'
    fi
    if [ -f ~/$SERVER/banned-players.json ] ## Filters ?
     then
      BANNED=$(jq length ~/$SERVER/banned-players.json)
     else
      BANNED='0'
    fi
# split filtering ?
    WHITELISTED=$(jq length ~/$SERVER/whitelist.json)
    OPS=$(jq length ~/$SERVER/ops.json)
      # FETCH ONLINE CONNECTIONS
#    PORT=$(grep server-port ~/$SERVER/server.properties | cut -d '=' -f 2)
    ONLINE=$(lsof -i -sTCP:ESTABLISHED | grep $PORT | wc -l)
    CALCONLINE=$(($ONLINE))

    if [ "$CALCONLINE" -lt "0" ]
     then
      CALCONLINE="0"
    fi
    # IF MINECRAFT SERVER IS RUNNING ON SAME SERVER AS PROXY SERVER
    #PROXY=$(grep online-mode ~/$SERVER/server.properties | cut -d '=' -f 2)
    #if [ "$PROXY" == "false" ]
    # then
    #  CALCONLINE=$(("$CALCONLINE"/2))
    #fi

#### DISPLAY STATISTICS IN STYLE - UNCOLORED
#    #printf "$ >> SERVER\n"
#    figlet "     $SERVER"
#    printf "TPS:$TPS | RAM:${USEDMEM}MB/${MAXMEM}MB | Player/Online:$USERCOUNT/$CALCONLINE$NORMAL | Banned:$BANNED | Whitelisted:$WHITELISTED | OP:$OPS\n"
#    #printf "$======================================================================================="

#### COLOURED
    printf "\n"
    tput setaf 4
    figlet " > >   $SERVER   < <"
#    figlet "$SERVERNR - > >   $SERVER   < <" #### AS IS NUMBER MESSES UP NR / LIST
    tput sgr0
    printf "${GREEN}TPS:$TPS$NORMAL  -  RAM:${USEDMEM}MB/${MAXMEM}MB  -  ${CYAN}Online/Player:$CALCONLINE/$USERCOUNT$NORMAL\n"
    printf "OP\'s:$OPS/$USERCOUNT  -  Banned:$BANNED/$USERCOUNT  -  ${WHITE}Whitelisted:$WHITELISTED/$USERCOUNT$NORMAL\n"
    printf "Uptime:$UPTIME\n"
#    printf "\n"

# Coloured spacer
#    tput setaf 4
#    printf "$SPACER_1"
#    tput sgr0
#
# Dynamic spacer
#    for (( WIDTH=1; WIDTH<=$WIDTHMAX; WIDTH++ ))
#     do
#      printf "$SPACER_0"
#    done

#### RRD UPDATE DATABASE HAPPENS LAST ########################################################################
    if [ -f ~/$SERVER/scripts/stats/$SERVER-Stats.rrd ]
     then
      rrdtool update ~/$SERVER/scripts/stats/$SERVER-Stats.rrd N:$TPS:$CALCONLINE:$USEDMEM	#
     else
      printf "RRD Stats not setup yet ..\n"
    fi
  fi
done

printf " \n"
printf " \n"

#### PRINT DYNAMIC FOOTER #######################################
for (( WIDTH=1; WIDTH<=$WIDTHMAX; WIDTH++ ))			#
 do								#
  printf "$SPACER_1"						#
done								#
#################################################################

#printf "$SPACER_2"
printf " \n"

#### REMAKE WITHE CASE ??
#### EOF ###
