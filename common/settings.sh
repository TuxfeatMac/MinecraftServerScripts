#!/bin/bash
#################################################################
# Name:         settings.sh           Version:      0.0.1       #
# Created:      22.12.2020            Modified:     06.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      change server settings with ease                #
#################################################################

# DISCLAIMER ! STILL "WORK" in PROGRESS....

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""			#
#########################################

#### ADJUST MENUE VARIABLES HERE ########################################
SPACER_1="=========================================================\n"	#
SPACER_2="+-------------------------------------------------------+\n"	#
#########################################################################

#### SET SOME COLOURS ####
##########################
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
GREY=$(tput setaf 8)	 #
CYAN=$(tput setaf 6)	 #
##########################

#### STATIC VARIABLES ###################
#########################################
PAPERYML=~/$SERVER/paper.yml		#
SPIGOTYML=~/$SERVER/spigot.yml		#
BUKKITYML=~/$SERVER/bukkit.yml		#
SERVERPROPS=~/$SERVER/server.properties	#
#########################################

#### SCRIPT OPTIONS #####
#########################
if [ "$1" != "" ]	#
 then			#
  case $1 in		#
  "-h")			#
   HELP="true";;	#
  "-m")			#
   MENUE="true";;	#
  esac			#
fi			#
if [ "$2" != "" ]	#
 then			#
  case $2 in		#
  "-h")			#
   HELP="true";;	#
  "-m")			#
   MENUE="true";;	#
  esac			#
fi			#
#########################

#### CHECK SETUP ########################################
#########################################################
if [ "$SERVER" == "" ]                                  #
 then                                                   #
  printf "[$RED EXIT $NORMAL] SERVER not set!\n"        #
  exit                                                  #
fi                                                      #
#########################################################

#### GET SERVERTYPE AND CHECK FOR CONFIG FILES AND DISPLAY INFOS ABOUT THEM #####
#################################################################################
for FILE in $SERVERPROPS $BUKKITYML $SPIGOTYML $PAPERYML			# <= Order is important for SERVERTYPE!
 do										#
  if [ -f $FILE ]								#
   then										#
    SERVERTYPE=$(ls $FILE | cut -d\/ -f5 | cut -d\. -f1)			#
    case $SERVERTYPE in								#
     paper)									#
      INFOTEXT=$(grep paper $PAPERYML)						#
      printf "$SPACER_1"							#
      printf "[ INFO ] $CYAN$SERVERTYPE$NORMAL config found using it\n"		#
      printf "[ INFO ] $FILE\n"							#
      if [ "$HELP" == "true" ]							#
       then									#
       printf "$GREY$INFOTEXT$NORMAL\n"						#
      fi;;									#
     spigot)									#
      INFOTEXT=$(grep spigot $SPIGOTYML)					#
      printf "$SPACER_1"							#
      printf "[ INFO ] $CYAN$SERVERTYPE$NORMAL config found using it\n"		#
      printf "[ INFO ] $FILE\n"							#
      if [ "$HELP" == "true" ]							#
       then									#
       printf "$GREY$INFOTEXT$NORMAL\n"						#
      fi;;									#
     bukkit)									#
      INFOTEXT=$(grep bukkit $BUKKITYML)					#
      printf "$SPACER_1"							#
      printf "[ INFO ] $CYAN$SERVERTYPE$NORMAL config found using it\n"		#
      printf "[ INFO ] $FILE\n"							#
      if [ "$HELP" == "true" ]							#
       then									#
       printf "$GREY$INFOTEXT$NORMAL\n"						#
      fi;;									#
     server)									#
      INFOTEXT=$(grep "Minecraft" $SERVERPROPS)					#
      printf "$SPACER_1"							#
      printf "[ INFO ] $CYAN$SERVERTYPE$NORMAL config found using it\n"		#
      printf "[ INFO ] $FILE\n"							#
      if [ "$HELP" == "true" ]							#
       then									#
       printf "$GREY# Minecraft Server Properies $NORMAL\n"			#
      fi;;									#
     *)										#
      printf "$SPACER_1"							#
      printf "[ INFO ] => $SERVERTYPE $FILE config not found\n"			#
    esac									#
  fi										#
done										#
################################################################################# reimplement for non paper

#### CHECKING SERVERTYPE ################################################
#########################################################################
if [ "$SERVERTYPE" != "" ]						#
 then									#
  printf "$SPACER_1"							#
  printf "[ INFO ] you are running => $GREEN$SERVERTYPE$NORMAL\n"	#
 else									#
  printf "$SPACER_1"							#
  printf "[ SKIP ] no configs found, abbort...\n"			#
  exit									#
fi									#
#########################################################################

#### CHECK IF SERVER IS RUNNING AND CONFIRM SERVERTYPE ##########################################
#################################################################################################
RUN=$(screen -list | grep -o "$SERVER")                                                         #
if [ "$RUN" == "$SERVER" ]                                                                      #
 then                                                                                           #
  printf "[$YELLOW WARN $NORMAL] $SERVER is running!\n"						#
  printf "[$YELLOW WARN $NORMAL] it is not recommendet to change settings now...\n" 		#
  read -n 1 -p "[  IN  ] [ y ] you really want to continue? : " INPUT				#
  if [ "$INPUT" != "y" ]									#
   then												#
    printf "Whise choice\n"									#
    exit											#
   else												#
    if [ "$MENUE" == "true" ]									#
     then											#
      clear											#
      sleep 0.25										#
    fi												#
    printf "$YELLOW=========================================================$NORMAL\n"		#
    printf "[$YELLOW WARN $NORMAL] $SERVER is running! \n"					#
    printf "$YELLOW=========================================================$NORMAL\n"		#
  fi												#
  else												#
   printf "[  IN  ] press <ENTER> to confirm / continue \n"					#
   read -n 1 -p "[  IN  ] or <CTLR> + <C> at any time to exit: " CONFIRM			#
   if [ "$CONFIRM" == "" ]									#
    then											#
    if [ "$MENUE" == "true" ]									#
     then											#
      clear											#
      sleep 0.25										#
    fi												#
    else											#
     printf "\n[$YELLOW SKIP$NORMAL] something is wrong here... EXIT! \n"			#
     exit											#
   fi												#
fi                                                                                              #
#################################################################################################


##server.properties
# online-mode
# server-port

# hardcore  needs world reset to work properly maybe

# white-list
# enforce-whitelist  # kick players

# level-type  needs world reset to work

# spawn-protection
# max-world-size   sets the worldboarder

# motd  ->  Messages ?


##bukkit.yml
# spawn-limits
#  monsters:
#  animals:
#  water-animals:
#  water-ambient:
#  ambient:
# ticks-per
# animal-spawns: 400
# monster-spawns:1 / 2
# water-spawns:1
# water-ambient-spawns
# ambient-spawns

##spigot.yml
# - Messages / sperat setup ?
# restart-on-crash
# restart-script
# netty-threads
# bungeecord

##paper.yml
# enable-player-collisions
# - Messages /seperat setup ?
# anti-xray
# disable-pillager-patrols
# disable-chest-cat-detection
# nerf-pigmen-from-nether-portals
# disable-end-credits
# zombies-target-turtle-eggs
# enable-tresure-maps
# all-chunks-are-slime-chunks
# nether-ceiling-void-damage-height
# keep-spawn-loaded
# keep-spawn-loaded-range: 8
# per-player-mob-spawns: false
# prevent-moving-into-unloaded-chunks:
# flat-bedrock: false


# SERVER MAX-PLAYERS ############################################################
printf "$SPACER_1"								#
printf "[ INFO ] MaxPlayers                                  <---\n"    	#
OLD_MAXPLAYER=$(grep ^max-players $SERVERPROPS | cut -d\= -f2)     		#
printf "[  IS  ] => $OLD_MAXPLAYER Player\n"                         		#
if [ "$HELP" == "true" ]							#
 then										#
  printf "$GREY[ HELP ] amount of players bevor server is full$NORMAL\n"	#
fi										#
read -n 3 -p "[  IN  ] [ 1 - 300 ] : " MAXPLAYER                      		#
case $MAXPLAYER in                                                   		#
 0)                                                                 		#
  MAXPLAYER=1                                                        		#
  printf "[$YELLOW INFO $NORMAL] Minimum is 1! setting it to 1\n";;		#
 [1-9]);;									#
 [1-9][0-9]);;									#
 [1-2][0-9][0-9]|300)								#
  printf "\n";;									#
 "")                                                                    	#
  MAXPLAYER=$OLD_MAXPLAYER                                        		#
  printf "[ SKIP ] unchanged...\n";;                                    	#
 *)                                                                     	#
  MAXPLAYER=$OLD_MAXPLAYER                                        		#
  printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n";;     	#
esac                                                                    	#
#################################################################################

#### SERVER VIEWDISTANCE ################################################
printf "=========================================================\n"	#
printf "[ INFO ] ViewDistance				     <---\n"	#
OLD_VIEWDISTANCE=$(grep ^view-distance $SERVERPROPS | cut -d\= -f2)	#
printf "[  IS  ] => $OLD_VIEWDISTANCE chunks\n"				#
read -n 2 -p "[  IN  ] [ 3 - 32 ] : " VIEWDISTANCE			#
case $VIEWDISTANCE in							#
 [0-2])									#
  VIEWDISTANCE=3							#
  printf "[$YELLOW INFO $NORMAL] Minimum is 3! setting it to 3\n";;	#
 [3-9]);;								#
 1[0-9]|2[0-9]|3[0-2])							#
  printf "\n";;								#
 "")									#
  VIEWDISTANCE=$OLD_VIEWDISTANCE					#
  printf "[ SKIP ] unchanged...\n";;					#
 *)									#
  VIEWDISTANCE=$OLD_VIEWDISTANCE					#
  printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n";;	#
esac									#
#########################################################################

#### PAPER NO-TICK-VIEW-DISTANCE ################################################################################################
if [ "$SERVERTYPE" = "paper" ]													#
 then																#
  printf "=========================================================\n"								#
  printf "[ INFO ] NoTickViewDistance                          <---\n"								#
  OLD_VIEWDISTANCENOTICK=$(grep no-tick-view-distance $PAPERYML | cut -d\: -f2 | cut -d ' ' -f2)				#
  MIN_VIEWDISTANCENOTICK=$(($VIEWDISTANCE+1))											#
  printf "[  IS  ] => $OLD_VIEWDISTANCENOTICK chunks\n"										#
  if [ "$HELP" == "true" ]													#
   then																#
    printf "$GREY[ HELP ] -1 is disabled must be greater ViewDistance ($VIEWDISTANCE)\n"					#
    printf "[ HELP ] load more passive chunks for increased view\n"								#
    printf "[ HELP ] only loads blocks in additional chunks $NORMAL\n"								#
  fi																#
  read -n 7 -p "[  IN  ] [ disable / -1 | $MIN_VIEWDISTANCENOTICK - 32 ] : " VIEWDISTANCENOTICK					#
  case $VIEWDISTANCENOTICK in													#
   disable|-1)															#
    VIEWDISTANCENOTICK=-1;;													#
   [0-3])															#
    VIEWDISTANCENOTICK=-1													#
    printf "[$YELLOW INFO $NORMAL] Minimum is 4! disabling it...\n";;								#
   [4-9]);;															#
   1[0-9]|2[0-9]|3[0-2]);;													#
   "")																#
    VIEWDISTANCENOTICK=$OLD_VIEWDISTANCENOTICK											#
    printf "[ SKIP ] unchanged...\n";;												#
   *)																#
    VIEWDISTANCENOTICK=$OLD_VIEWDISTANCENOTICK											#
    printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n";;								#
  esac																#
  if [ "$VIEWDISTANCENOTICK" != "-1" -a "$VIEWDISTANCE" -gt "$VIEWDISTANCENOTICK" -o "$VIEWDISTANCE" == "$VIEWDISTANCENOTICK" ]	#
   then																#
    VIEWDISTANCENOTICK=-1													#
    printf "[$YELLOW INFO $NORMAL] must be greater ViewDistance ($VIEWDISTANCE) disabling it...\n"				#
  fi																#
fi																#
#################################################################################################################################

#### SERVER GAMEMODE ############################################################
printf "$SPACER_1"								#
printf "[ INFO ] GameMode				     <---\n"		#
OLD_GAMEMODE=$(grep ^gamemode $SERVERPROPS | cut -d\= -f2)			#
printf "[  IS  ] => $OLD_GAMEMODE \n"						#
if [ "$HELP" == "true" ]							#
 then										#
  printf "$GREY[ HELP ] sets the default GameMode on first join$NORMAL\n"	#
fi										#
printf "[ -> 0 ] survival\n"							#
printf "[ -> 1 ] creative\n"							#
printf "[ -> 2 ] adventure\n"							#
printf "[ -> 3 ] spectator\n"							#
read -n 10 -p "[  IN  ] : " GAMEMODE						#
case $GAMEMODE in								#
 0|survival)									#
  GAMEMODE=survival;;								#
 1|creative)									#
  GAMEMODE=creative;;								#
 2|adventure)									#
  GAMEMODE=adventure;;								#
 3|spectator)									#
  GAMEMODE=spectator;;								#
 "")										#
  printf "[ SKIP ] unchanged...\n"						#
  GAMEMODE=$OLD_GAMEMODE;;							#
 *)										#
  printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n"		#
  GAMEMODE=$OLD_GAMEMODE;;							#
esac										#
#################################################################################

#### SERVER FORCE-GAMEMODE ##############################################################
printf "=========================================================\n"			#
printf "[ INFO ] ForceGameMode				     <---\n"			#
OLD_GAMEMODEFORCE=$(grep ^force-gamemode $SERVERPROPS | cut -d\= -f2)			#
printf "[  IS  ] => $OLD_GAMEMODEFORCE \n"						#
if [ "$HELP" == "true" ]								#
 then											#
  printf "$GREY[ HELP ] reset the GameMode on join to default Gamemode$NORMAL\n"	#
fi											#
read -n 1 -p "[  IN  ] [ y | n ]: " GAMEMODEFORCE					#
case $GAMEMODEFORCE in									#
 t|y|1)											#
  GAMEMODEFORCE=true									#
  printf "\n";;										#
 f|n|0)											#
  GAMEMODEFORCE=false									#
  printf "\n";;										#
 "")											#
  printf "[ SKIP ] unchanged...\n"							#
  GAMEMODEFORCE=$OLD_GAMEMODEFORCE;;							#
 *)											#
  printf "\n[$YELLOW SKIP $NORMAL] wrong input unchanged...\n"				#
  GAMEMODEFORCE=$OLD_GAMEMODEFORCE;;							#
esac											#
#########################################################################################

#### SERVER DIFFICULTY ############################################################
printf "$SPACER_1"                                                              #
printf "[ INFO ] Difficulty                                    <---\n"            #
OLD_DIFFICULTY=$(grep ^difficulty $SERVERPROPS | cut -d\= -f2)                      #
printf "[  IS  ] => $OLD_DIFFICULTY \n"                                           #
if [ "$HELP" == "true" ]                                                        #
 then                                                                           #
  printf "$GREY[ HELP ] sets the difficulty$NORMAL\n"       #
fi                                                                              #
printf "[ -> 0 ] peacefull\n"                                                    #
printf "[ -> 1 ] easy\n"                                                    #
printf "[ -> 2 ] normal\n"                                                   #
printf "[ -> 3 ] hard\n"                                                   #
read -n 10 -p "[  IN  ] : " DIFFICULTY                                            #
case $DIFFICULTY in                                                               #
 0|peacefull)                                                                    #
  DIFFICULTY=peacefull;;                                                           #
 1|easy)                                                                    #
  DIFFICULTY=easy;;                                                           #
 2|normal)                                                                   #
  DIFFICULTY=normal;;                                                          #
 3|hard)                                                                   #
  DIFFICULTY=hard;;                                                          #
 "")                                                                            #
  printf "[ SKIP ] unchanged...\n"                                              #
  DIFFICULTY=$OLD_DIFFICULTY;;                                                      #
 *)                                                                             #
  printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n"               #
  DIFFICULTY=$OLD_DIFFICULTY;;                                                      #
esac                                                                            #
#################################################################################  world deletion needed ? / gameruleedits ?

#### SERVER PVP #################################################################
printf "$SPACER_1"            							#
printf "[ INFO ] PlayerVsPLayer                              <---\n"            #
OLD_PVP=$(grep ^pvp $SERVERPROPS | cut -d\= -f2)           			#
printf "[  IS  ] => $OLD_PVP \n"                                      		#
if [ "$HELP" == "true" ]							#
 then										#
  printf "$GREY[ HELP ] players can fight against each other$NORMAL\n"        	#
fi										#
read -n 1 -p "[  IN  ] [ y | n ]: " PVP                               		#
case $PVP in                                                          		#
 t|y|1)                                                                         #
  PVP=true                                                            		#
  printf "\n";;                                                                 #
 f|n|0)                                                                         #
  PVP=false                                                           		#
  printf "\n";;                                                                 #
 "")                                                                            #
  printf "[ SKIP ] unchanged...\n"                                              #
  PVP=$OLD_PVP;;                                            			#
 *)                                                                             #
  printf "\n[$YELLOW SKIP $NORMAL] wrong input unchanged...\n"                  #
  PVP=$OLD_PVP;;                                            			#
esac                                                                            #
#################################################################################

#### SERVER STRUCTURES ##########################################################
printf "$SPACER_1"								#
printf "[ INFO ] GenerateStructures                              <---\n"	#
OLD_STRUCTURES=$(grep ^generate-structures $SERVERPROPS | cut -d\= -f2)		#
printf "[  IS  ] => $OLD_STRUCTURES \n"                				#
if [ "$HELP" == "true" ]                                                        #
 then                                                                           #
  printf "$GREY[ HELP ] generate structures Villages, Portals, ...$NORMAL\n"	#
fi                                                                              #
read -n 1 -p "[  IN  ] [ y | n ]: " STRUCTURES                 			#
case $STRUCTURES in                               				#
 t|y|1)                                                                         #
  STRUCTURES=true								#
  printf "\n";;                                                                 #
 f|n|0)                                                                         #
  STRUCTURES=false								#
  printf "\n";;                                                                 #
 "")                                                                            #
  printf "[ SKIP ] unchanged...\n"                                              #
  STRUCTURES=$OLD_STRUCTURES;;							#
 *)                                                                             #
  printf "\n[$YELLOW SKIP $NORMAL] wrong input unchanged...\n"                  #
  STRUCTURES=$OLD_STRUCTURES;;                          			#
esac                                                                            #
#################################################################################  world deletion needed...

#### SERVER SPAWN-NPCS #######################################################
printf "$SPACER_1"                                                                #
printf "[ INFO ] SpawnNpcs                                <---\n"            #
OLD_NPCS=$(grep ^spawn-npcs $SERVERPROPS | cut -d\= -f2)                  #
printf "[  IS  ] => $OLD_NPCS \n"                                            #
if [ "$HELP" == "true" ]                                                        #
 then                                                                           #
  printf "$GREY[ HELP ] enables or disables Villager, WanderingTrader...  $NORMAL\n"                  #
fi                                                                              #
read -n 1 -p "[  IN  ] [ y | n ]: " NPCS                                     	#
case $NPCS in                                                                	#
 t|y|1)                                                                         #
  NPCS=true                                                                  	#
  printf "\n";;                                                                 #
 f|n|0)                                                                         #
  NPCS=false                                                                 	#
  printf "\n";;                                                                 #
 "")                                                                            #
  printf "[ SKIP ] unchanged...\n"                                              #
  NPCS=$OLD_NPCS;;                                                        	#
 *)                                                                             #
  printf "\n[$YELLOW SKIP $NORMAL] wrong input unchanged...\n"                  #
  NPCS=$OLD_NPCS;;                                                        	#
esac                                                                            #
#################################################################################  allso disable them in paper.yml ?

#### SERVER SPAWN-ANIMALS #######################################################
printf "$SPACER_1"            							#
printf "[ INFO ] SpawnAnimals                                <---\n"		#
OLD_ANIMALS=$(grep ^spawn-animals $SERVERPROPS | cut -d\= -f2)           	#
printf "[  IS  ] => $OLD_ANIMALS \n"						#
if [ "$HELP" == "true" ]							#
 then										#
  printf "$GREY[ HELP ] enables or disables Animals $NORMAL\n"   	     	#
fi										#
read -n 1 -p "[  IN  ] [ y | n ]: " ANIMALS                               	#
case $ANIMALS in                                                          	#
 t|y|1)                                                                         #
  ANIMALS=true                                                            	#
  printf "\n";;                                                                 #
 f|n|0)                                                                         #
  ANIMALS=false                                                           	#
  printf "\n";;                                                                 #
 "")                                                                            #
  printf "[ SKIP ] unchanged...\n"                                              #
  ANIMALS=$OLD_ANIMALS;;                                            		#
 *)                                                                             #
  printf "\n[$YELLOW SKIP $NORMAL] wrong input unchanged...\n"                  #
  ANIMALS=$OLD_ANIMALS;;							#
esac                                                                            #
#################################################################################

#### SERVER SPAWN-MONSTERS ######################################################
printf "$SPACER_1"                                                              #
printf "[ INFO ] SpawnMonster                                <---\n"            #
OLD_MONSTER=$(grep ^spawn-monsters $SERVERPROPS | cut -d\= -f2)                 #
printf "[  IS  ] => $OLD_MONSTER \n"                                            #
if [ "$HELP" == "true" ]                                                        #
 then                                                                           #
  printf "$GREY[ HELP ] enables or disables Monster $NORMAL\n"                  #
fi                                                                              #
read -n 1 -p "[  IN  ] [ y | n ]: " MONSTER                                     #
case $MONSTER in                                                                #
 t|y|1)                                                                         #
  MONSTER=true                                                                  #
  printf "\n";;                                                                 #
 f|n|0)                                                                         #
  MONSTER=false                                                                 #
  printf "\n";;                                                                 #
 "")                                                                            #
  printf "[ SKIP ] unchanged...\n"                                              #
  MONSTER=$OLD_MONSTER;;                                                        #
 *)                                                                             #
  printf "\n[$YELLOW SKIP $NORMAL] wrong input unchanged...\n"                  #
  MONSTER=$OLD_MONSTER;;                                                        #
esac                                                                            #
#################################################################################

#### SERVER ALLOW_NETHER ################################################
printf "=========================================================\n"	#
printf "[ INFO ] Nether					     <---\n"	#
OLD_ALLOWNETHER=$(grep ^allow-nether $SERVERPROPS | cut -d\= -f2)	#
printf "[  IS  ] => $OLD_ALLOWNETHER \n"				#
if [ "$HELP" == "true" ]						#
 then									#
  printf "$GREY[ HELP ] enable or dissable the Nether World$NORMAL\n"	#
fi									#
read -n 1 -p "[  IN  ] [ y | n ]: " ALLOWNETHER				#
case $ALLOWNETHER in							#
 t|y|1)									#
  ALLOWNETHER=true							#
  printf "\n";;								#
 f|n|0)									#
  ALLOWNETHER=false							#
  printf "\n";;								#
 "")									#
  printf "[ SKIP ] unchanged...\n"					#
  ALLOWNETHER=$OLD_ALLOWNETHER;;					#
 *)									#
  printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n"	#
  ALLOWNETHER=$OLD_ALLOWNETHER;;					#
esac									#
#########################################################################

#### BUKKIT ALLOW_END ###################################################################
if [ "$SERVERTYPE" = "paper" -o "$SERVERTYPE" = "spigot" -o "$SERVERTYPE" = "bukkit" ]	#
 then											#
  printf "=========================================================\n"			#
  printf "[ INFO ] The End                                     <---\n"			#
  OLD_ALLOWEND=$(grep allow-end $BUKKITYML | cut -d\: -f2 | cut -d ' ' -f2)		#
  printf "[  IS  ] => $OLD_ALLOWEND \n"							#
  if [ "$HELP" == "true" ]								#
   then											#
   printf "$GREY[ HELP ] enable or dissable the The End World$NORMAL\n"			#
  fi											#
  read -n 1 -p "[  IN  ] [ y | n ]: " ALLOWEND						#
  case $ALLOWEND in									#
   t|y|1)										#
    ALLOWEND=true									#
    printf "\n";;									#
   f|n|0)										#
    ALLOWEND=false									#
    printf "\n";;									#
   "")											#
    printf "[ SKIP ] unchanged...\n"							#
    ALLOWEND=$OLD_ALLOWEND;;								#
   *)											#
    printf "\n[$YELLOW SKIP $NORMAL] wrong input... unchanged...\n"			#
    ALLOWEND=$OLD_ALLOWEND;;								#
  esac											#
fi											#
#########################################################################################

#### LIST CHANGES ###############################################################################
if [ "$MENUE" == "true" ]									#
 then												#
  clear												#
  sleep 0.25											#
fi												#
printf "$SPACER_1"										#
printf "[ INFO ] Summery Change List			     <---\n"				#
printf "$SPACER_2"										#
if [ "$OLD_MAXPLAYER" != "$MAXPLAYER" ]								#
 then
  printf "> MaxPlayers:\t\t$OLD_MAXPLAYER\t=>\t$MAXPLAYER\n"
  CHANGE="y"
fi
if [ "$OLD_VIEWDISTANCE" != "$VIEWDISTANCE" ]
 then
  printf "> ViewDistance:\t\t$OLD_VIEWDISTANCE\t=>\t$VIEWDISTANCE\n"
  CHANGE="y"
fi
if [ "$OLD_VIEWDISTANCENOTICK" != "$VIEWDISTANCENOTICK" ]
 then
  printf "> NoTickViewDistance:\t$OLD_VIEWDISTANCENOTICK\t=>\t$VIEWDISTANCENOTICK\n"	#
  CHANGE="y"
fi
if [ "$OLD_GAMEMODE" != "$GAMEMODE" ]
 then
  printf "> GameMode:\t$OLD_GAMEMODE\t=>\t$GAMEMODE\n"
  CHANGE="y"
fi
if [ "$OLD_GAMEMODEFORCE" != "$GAMEMODEFORCE" ]
 then
  printf "> ForceGameMode:\t\t$OLD_GAMEMODEFORCE\t=>\t$GAMEMODEFORCE\n"
  CHANGE="y"
fi
if [ "$OLD_DIFFICULTY" != "$DIFFICULTY" ]
 then
  printf "> Difficulty:\t\t$OLD_DIFFICULTY\t=>\t$DIFFICULTY\n"
  CHANGE="y"
fi
if [ "$OLD_STRUCTURES" != "$STRUCTURES" ]
 then
  printf "> Structures:\t$OLD_STRUCTURES\t=>\t$STRUCTURES\n"
  CHANGE="y"
fi
if [ "$OLD_PVP" != "$PVP" ]
 then
  printf "> PlayerVsPlayer:\t$OLD_PVP\t=>\t$PVP\n"
  CHANGE="y"
fi
if [ "$OLD_NPCS" != "$NPCS" ]
 then
  printf "> SpawnNpcs:\t\t$OLD_NPCS\t=>\t$NPCS\n"
  CHANGE="y"
fi
if [ "$OLD_ANIMALS" != "$ANIMALS" ]
 then
  printf "> SpawnAnimals:\t\t$OLD_ANIMALS\t=>\t$ANIMALS\n"
  CHANGE="y"
fi
if [ "$OLD_MONSTER" != "$MONSTER" ]
 then
  printf "> SpawnMonster:\t\t$OLD_MONSTER\t=>\t$MONSTER\n"
  CHANGE="y"
fi
if [ "$OLD_ALLOWNETHER" != "$ALLOWNETHER" ]
 then
  printf "> NetherWorld:\t\t$OLD_ALLOWNETHER\t=>\t$ALLOWNETHER\n"
  CHANGE="y"
fi
if [ "$OLD_ALLOWEND" != "$ALLOWEND" ]
 then
  printf "> EndWorld:\t\t$OLD_ALLOWEND\t=>\t$ALLOWEND\n"
  CHANGE="y"
fi												#
#################################################################################################

#### REALLY APPLY CHANGES ###############################################
#########################################################################
if [ "$CHANGE" != "y" ]							#
 then									#
  printf "[ INFO ] no changes\n"					#
  printf "$SPACER_2"							#
  printf "[$GREEN DONE $NORMAL] nothing changed, nothing to do...\n"	#
  exit									#
fi									#
printf "$SPACER_2"							#
read -n 1 -p "[  IN  ] [ y / n ] apply listed changes? : " INPUT	#
 if [ "$INPUT" != "y" ]							#
  then									#
   printf "\n$SPACER_1"							#
   exit									#
  else									#
   printf "\n$SPACER_1"							#
fi									#
#########################################################################

#### APPLY CHANGES ######################################################################################################
## SERVER.ROPERTIES													#
if [ "$SERVERTYPE" == "paper" -o "$SERVERTYPE" == "spigot" -o "$SERVERTYPE" == "bukkit" -o "$SERVERTYPE" == "server" ]	#
 then
  sed -i "s|^max-players=.*|max-players=$MAXPLAYER|" $SERVERPROPS
  sed -i "s|^view-distance=.*|view-distance=$VIEWDISTANCE|" $SERVERPROPS
  sed -i "s|^gamemode=.*|gamemode=$GAMEMODE|" $SERVERPROPS
  sed -i "s|^force-gamemode=.*|force-gamemode=$GAMEMODEFORCE|" $SERVERPROPS
  sed -i "s|^difficulty=.*|difficulty=$DIFFICULTY|" $SERVERPROPS
  sed -i "s|^generate-structures=.*|generate-structures=$STRUCTURES|" $SERVERPROPS
  sed -i "s|^pvp=.*|pvp=$PVP|" $SERVERPROPS
  sed -i "s|^spawn-npcs=.*|spawn-npcs=$NPCS|" $SERVERPROPS
  sed -i "s|^spawn-animals=.*|spawn-animals=$ANIMALS|" $SERVERPROPS
  sed -i "s|^spawn-monsters=.*|spawn-monsters=$MONSTER|" $SERVERPROPS
  sed -i "s|^allow-nether=.*|allow-nether=$ALLOWNETHER|" $SERVERPROPS
fi
## BUKKIT.YML
if [ "$SERVERTYPE" == "paper" -o "$SERVERTYPE" == "spigot" -o "$SERVERTYPE" == "bukkit" ]
 then
  sed -i "s|allow-end:.*|allow-end: $ALLOWEND|" $BUKKITYML
fi

## SPIGOT.YML
#if [ "$SERVERTYPE" == "paper" -o "$SERVERTYPE" == "spigot" ]
# then
#  sed -i "s|allow-end:.*|allow-end:$ALLOWEND|" $SPIGOTYML
#fi

## PAPER.YML
if [ "$SERVERTYPE" == "paper" ]
 then
  sed -i "s|no-tick-view-distance:.*|no-tick-view-distance: $VIEWDISTANCENOTICK|" $PAPERYML
fi															#
#########################################################################################################################

#### DONE MESSAGE #######################
printf "[$GREEN DONE $NORMAL]\n"	#
#########################################
