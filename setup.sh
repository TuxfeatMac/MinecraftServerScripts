#!/bin/bash
#################################################################
# Name:         setup.sh              Version:      0.3.0       #
# Created:      06.12.2020            Modified:     07.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      setup a new MineCraftServer, with ease          #
#################################################################

#### STATIC VARIABELS AND DIRECTORIES ###################################
#########################################################################
SCRIPTS="MinecraftServerScripts-0_3_0"      # -ORIGINAL-SCRIPTS-FOLDER- #
SPACER_1="="								#
#########################################################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
GREY=$(tput setaf 8)     #
##########################

#### DEFINE DYINAMIC SEPERATOR LINE #############################################
dynline1() {									#
if [ "$SSH_TTY" != "" ]								#
 then										#
  WIDTHMAX=$(stty -a <$SSH_TTY | grep -Po '(?<=columns )\d+')   		#
 else										#
 WIDTHMAX=$(tput cols)								#
fi										#
  for (( WIDTH=1; WIDTH<=$WIDTHMAX; WIDTH++ ))                 			#
   do                                                           		#
    printf "$SPACER_1"                                          		#
  done                                                          		#
}										#
#################################################################################

#### DISPLAY INFOS ##############################################################
dynline1									#
printf "| This script can be used to set up a new Server or to \n"		#
printf "| replace the old scripts with a new script version    \n"		#
printf "|	     $GREY created by Joachim Traeuble	$NORMAL \n"		#
dynline1									#
#################################################################################

#### BASIC DEPENDENCY CHECK #####################################
~/$SCRIPTS/common/checkdependencies.sh	--noversioncheck	#
#################################################################

#### GET AND SET THE SERVERNAME #################################
read -p "[  IN  ] ServerName ? : " SERVER			#
if [ "$SERVER" == "" ]						#
 then								#
  printf "[$YELLOW SKIP $NORMAL] no input... abbort\n"		#
  exit								#
 else								#
  printf "[$GREEN  OK  $NORMAL] ServerName set => $SERVER\n"	#
fi								#
#################################################################

#### CHECK IF IT IS A NEW SERVER / SERVER DIR OR JUST REPLACE THE OLD SCRIPTS ###################################
if [ -d ~/$SERVER ]												#
 then														#
  tput setaf 3 && dynline1 && tput sgr0										#
  printf "[$YELLOW WARN $NORMAL] => $RED$SERVER$NORMAL already exits!\n"					#
  read -t 15 -p "[$YELLOW  IN  $NORMAL] [ y / n ]$RED override$NORMAL existing scripts? : " INPUT		#
  if [ "$INPUT" == "y" ]                                                       					#
   then                                                                         				#
    OVERRIDE="y"												#
    tput setaf 3 && dynline1 && tput sgr0										#
   else                                                                         				#
    tput setaf 3 && dynline1 && tput sgr0										#
    printf "[$YELLOW SKIP $NORMAL] abbort...\n"									#
    exit													#
  fi														# automaticaly determine type ?
fi														#
#################################################################################################################

#### GET AND SET THE SERVERTYPE #################################################################################
read -p "[  IN  ] [ vanilla / paper ] ServerType ? : " SERVERTYPE						#
#read -p "[  IN  ] [ vanilla / snapshot / paper / velocity / bukkit / spigot ] ServerType ? : " SERVERTYPE	# no support for: waterfall, bungeecord, ... proxy setup seperate script !/?
case "$SERVERTYPE" in												#
 "")														#
  SERVERTYPE="vanilla"												#
  printf "[$GREEN  OK  $NORMAL] using default => $SERVERTYPE\n";;						#
 vanilla)													#
  printf "[$GREEN  OK  $NORMAL] using => $SERVERTYPE\n";;							#
 snapshot)													#
  printf "[$YELLOW SKIP $NORMAL] unsupported / in dev abbort...\n"						#
  exit;;													#
 paper)														#
  printf "[$GREEN  OK  $NORMAL] using => $SERVERTYPE\n";;							#
 velocity)													#
  printf "[$YELLOW SKIP $NORMAL] unsupported / in dev abbort...\n"						#
  exit;;													#
 bukkit)													#
  printf "[$YELLOW SKIP $NORMAL] unsupported / in dev abbort...\n"						#
  exit;;													#
 spigot)													#
  printf "[$YELLOW SKIP $NORMAL] unsupported / in dev abbort...\n"						#
  exit;;													#
 *)														#
  printf "[$YELLOW SKIP $NORMAL] unknown server type / invalid input abbort...\n"				#
  exit;;													#
esac														#
#################################################################################################################

#### GET AND SET JAVA SERVER RAM SIZE, FOR start.sh SCRIPT  #####
read -p "[  IN  ] [ 1024M ] Ram? : " RAM			#
case "$RAM" in							#
 "")								#
  RAM=${RAM:-1024M}						#
  printf "[$GREEN  OK  $NORMAL] using the minimum => $RAM\n";;	#
 *M)								#
  RAM=$RAM							#
  printf "[$GREEN  OK  $NORMAL] Ram is set to: $RAM\n";;	#
 *G)								#
  RAM=$RAM							#
  printf "[$GREEN  OK  $NORMAL] Ram is set to: $RAM\n";;	#
 *)								#
  RAM=$RAM							#
  printf "[$YELLOW SKIP $NORMAL] invalid input abbort...\n"	#
  exit;;							#
esac								#
#################################################################

#### GET AND SET THE SERVER PORT FOR FIRSTRUN ###################
read -p "[  IN  ] [ 25565 ] Port? : " PORT			#
case "$PORT" in                                                 #
 "")								#
  PORT=${PORT:-25565}                                           #
  printf "[$GREEN  OK  $NORMAL] using default => $PORT\n";;     #
 *)                                                             #
  printf "[$GREEN  OK  $NORMAL] Port is set to: $PORT\n";;      #

#  "NUMBER")                                                     # Filter invalid ports , at least allow noly numbers
#   RAM=$RAM                                                     #
#   printf "[$GREEN  OK  $NORMAL] Ram is set to: $RAM\n";;       #
#  *)                                                            #
#   RAM=$RAM                                                     #
#   printf "[$YELLOW SKIP $NORMAL] invalid input abbort...\n"    #
#   exit;;                                                       #

esac                                                            #
#################################################################

#### VANILLA #### GET AND SET THE SERVERVERSION #################################
if [ "$SERVERTYPE" == "vanilla" ]                                               #  redising check against mojang versions
 then										#
  printf "[ INFO ] fetching vanilla versions...\n"				#
  LATESTRELEASE=$(~/$SCRIPTS/vanilla/optional/getlatestversion.sh)		#
  read -p "[  IN  ] [ "$LATESTRELEASE" ] Version? : " VERSION			#
  case "$VERSION" in                                                            #
   "")                                                                       	# get latest default
    VERSION=${VERSION:-$LATESTRELEASE}                                          #
    printf "[$GREEN   OK   $NORMAL] using official latest => $VERSION\n";;	#
   *)                                                         	                #
    printf "[$YELLOW  OK  $NORMAL] trying version => $VERSION , checking...\n"	#
    EXISTS=$(~/$SCRIPTS/vanilla/optional/versionexits.sh $VERSION)		# checks for valid version, if not vaild exits, test worlking exit main script                                                                                #
    if [ "$EXISTS" == "" ]
     then
      VERSION="$VERSION"
      UNCHECKED="y"								# UNCHECKED flagg means nothing for now
     else
      printf "[ EXIT ] $version is not a valid version \n" #
    fi
  esac                                                                          #
  rm versions.json								#
fi                                                                              #
#################################################################################

#### PAPER #### GET AND SET THE SERVERVERSION ###################################################
if [ "$SERVERTYPE" == "paper" ]									#    add the other server versions
 then												#
  read -p "[  IN  ] [ 1.18 ] Version? : " VERSION						#
  case "$VERSION" in										#
   "")												#
    VERSION=${VERSION:-1.18}									#
    printf "[$GREEN  OK  $NORMAL] using default => $VERSION\n";;				#
   1.18)                                                                                      #
    VERSION="1.18"                                                                            #
    printf "[$GREEN  OK  $NORMAL] using => $VERSION\n";;
   1.17.1)											#
    VERSION="1.17.1"										#
    printf "[$GREEN  OK  $NORMAL] using => $VERSION\n";;					#
   1.16.5)											#
    VERSION="1.16.5"										#
    printf "[$GREEN  OK  $NORMAL] using => $VERSION\n";;					#
   1.12.2)											#	add more versions?
    VERSION="1.12.2"										#
    UNTESTED="y"										#
    tput setaf 3 && dynline1 && tput sgr0										#
    printf "[$YELLOW WARN $NORMAL] untested version... trying to setup $VERSION\n"		#
    tput setaf 3 && dynline1 && tput sgr0;;										#
   1.8.8)											#	add more versions?
    VERSION="1.8.8"										#
    UNTESTED="y"										#
    tput setaf 3 && dynline1 && tput sgr0										#
    printf "[$YELLOW WARN $NORMAL] untested version... trying to setup $VERSION\n"		#
    tput setaf 3 && dynline1 && tput sgr0;;										#
   *)												#
    printf "[$YELLOW SKIP $NORMAL] invalid input abbort...\n"					#
    exit;;											#
  esac												#
fi												#
#################################################################################################


#### SNAPSHOT SERVER ############################################
#if [ "$SERVERTYPE" == "velocity" ]				#
# then								#
#fi								#
#################################################################


#### SNAPSHOT SERVER ############################################
#if [ "$SERVERTYPE" == "snapshot" ]				#
# then								#
#  OVERRIDE="y"   # change y to true ?				#
#fi								#
################################################################# <-- add the other server types ...


#### REALLY #####################################################################################
if [ "$UNTESTED" == "y" ] && [ "$OVERRIDE" == "y" ]						#
 then												#
  tput setaf 2 && dynline1 && tput sgr0										#
  read -t 10 -n 1 -p "[$RED  IN  $NORMAL] [ y / n ] you have done your backups? : " INPUT	#
  if [ "$INPUT" != "y" ]									#
   then												#
    printf "\n"											#
    exit											#
   else												#
    tput setaf 2 && dynline1 && tput sgr0										#
  fi												#
  ###############################################################################################
  read -t 10 -n 1 -p "[$RED  IN  $NORMAL] [ y / n ] you really know what you doing? : " INPUT	#
  if [ "$INPUT" != "y" ]									#
   then												#
    printf "\n"											#
    exit											#
   else												#
    tput setaf 2 && dynline1 && tput sgr0										#
  fi												#
fi												#
#################################################################################################

#### CREATING DIRS IF NONEXISTING AND COPY SCRIPTS ######
mkdir -p ~/$SERVER 					#
mkdir -p ~/$SERVER/scripts				#
cp ~/$SCRIPTS/common/*.sh ~/$SERVER/scripts/		#
cp ~/$SCRIPTS/$SERVERTYPE/*.sh ~/$SERVER/scripts/	#
cd ~/$SERVER/scripts					#
#########################################################

#### SETUP NEW SCRIPTS TO MATCH THE NEW / OLD SERVER ####################################
sed -i "s|SERVER=\"\"|SERVER=\"$SERVER\"|" ~/$SERVER/scripts/*.sh	#
sed -i "s|SERVERTYPE=\"\"|SERVERTYPE=\"$SERVERTYPE\"|" ~/$SERVER/scripts/*.sh	#
sed -i "s|VERSION=\"\"|VERSION=\"$VERSION\"|" ~/$SERVER/scripts/*.sh	#
sed -i "s|RAM=\"\"|RAM=\"$RAM\"|" ~/$SERVER/scripts/*.sh		#
sed -i "s|SCRIPTS=\"\"|SCRIPTS=\"$SCRIPTS\"|" ~/$SERVER/scripts/*.sh	# needed ? placeholder
printf "[$GREEN DONE $NORMAL] scripts updated and in place\n"		#
#########################################################################

#### UNTESTED SETUP #####################################################################
if [ "$UNTESTED" == "y" ]								#
 then											#
  dynline1
  printf "[ INFO ] creating nessesary dirs...\n"					#
  mkdir ~/$SERVER/plugins > /dev/null 2>&1						#
  mkdir ~/$SERVER/scripts/update > /dev/null 2>&1					#
  mkdir ~/$SERVER/scripts/update/$SERVERTYPE > /dev/null 2>&1				#
  mkdir ~/$SERVER/scripts/update/plugins > /dev/null 2>&1				#
  mkdir ~/$SERVER/scripts/update/plugins/man > /dev/null 2>&1				#
  mkdir ~/$SERVER/scripts/update/plugins/new > /dev/null 2>&1				#
  mkdir ~/$SERVER/scripts/update/plugins/temp > /dev/null 2>&1				#
  printf "[$GREEN DONE $NORMAL] dirs created!\n"					#
  #######################################################################################
  dynline1
  printf "[ INFO ] accepting the EULA...\n"						#
  touch ~/$SERVER/eula.txt								#
  printf "eula=true" > ~/$SERVER/eula.txt						#
  printf "[$GREEN INFO $NORMAL] EULA accepted!\n"					#
  dynline1
  #######################################################################################
  ./serverupdate.sh									#
  dynline1
  #######################################################################################
  ./pluginupdate.sh									#
  dynline1
  #######################################################################################
  ./applyupdate.sh									#
  #######################################################################################
  tput setaf 2 && dynline1 && tput sgr0										#
  printf "[$RED WARN $NORMAL] use this setup at your own risk!\n"			#
  printf "[$RED WARN $NORMAL] some scripts may be not compatible!\n"			#
  tput setaf 2 && dynline1 && tput sgr0										#
  printf "[$GREEN DONE $NORMAL] setup done...\n"					#
  exit											#
fi											#
#########################################################################################

#### FIRSTRUN SERVER SETUP ##############################################
if [ "$OVERRIDE" == "" ]						#
 then									#
  dynline1
  printf "[ INFO ] this is a new Server!\n"				#
  #######################################################################
  printf "[ INFO ] creating nessesary dirs...\n"			#
  mkdir ~/$SERVER/plugins						#
  mkdir ~/$SERVER/scripts/update					#
  mkdir ~/$SERVER/scripts/update/$SERVERTYPE				#
  mkdir ~/$SERVER/scripts/update/plugins				#
  mkdir ~/$SERVER/scripts/update/plugins/man				#
  mkdir ~/$SERVER/scripts/update/plugins/new				#
  mkdir ~/$SERVER/scripts/update/plugins/temp				#
  printf "[$GREEN DONE $NORMAL] dirs created!\n"			#
  #######################################################################
  dynline1
  ./checkdependencies.sh						#
  dynline1
  printf "[ INFO ] accepting the EULA...\n"				#
  touch ~/$SERVER/eula.txt						#
  printf "eula=true" > ~/$SERVER/eula.txt				#
  printf "[$GREEN INFO $NORMAL] EULA accepted!\n"			#
  #######################################################################
  dynline1
  ./selectplugins.sh							#
  #######################################################################
  dynline1
  ./serverupdate.sh							#
  #######################################################################
  dynline1
  ./pluginupdate.sh							#
  #######################################################################
  dynline1
  ./applyupdate.sh							#
  #######################################################################
  touch ~/$SERVER/server.properties					#
  printf "server-port=$PORT" > ~/$SERVER/server.properties		#
  printf "[$GREEN INFO $NORMAL] Server Port set to $PORT\n"		#  fixed 25500 for now
  dynline1
  printf "[ INFO ] starting $SERVER for the first time...\n" 		#  stop server as soon as possible again
  printf "[ INFO ] this may take a while, please be patient...\n" 	#
  ./start.sh -b								#
  sleep 10								#
  printf "[ WAIT ] "							#
  RUN=$(screen -list | grep -o "$SERVER");                              #
  while [ "$RUN" != "" ]                                                #
   do									#
    printf "."								#
    screen -S $SERVER -X stuff 'stop\n'                                 #
    sleep 10;                                                           #
    RUN=$(screen -list | grep -o "$SERVER");                            #
    printf "."								#
  done                                                                  #
  printf "\n[$GREEN DONE $NORMAL] $SERVER is down again!\n"		#
  #######################################################################
  dynline1
  printf "[ INFO ] configrue your Server Settings\n"	 		#  ask for settings ?
  ./settings.sh -h							#
  #######################################################################  implement settings modifing
 else									#
 dynline1
 #./selectplugins.sh							#
fi									#
#########################################################################  configure settings

#### DISPLAY FINAL INFOS ################################################
dynline1
printf "[$GREEN DONE $NORMAL] setup complete!\n"			#
dynline1
printf "[ INFO ] use ~/$SERVER/scripts/start.sh to start server now\n"	#
#########################################################################
