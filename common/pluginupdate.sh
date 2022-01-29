#!/bin/bash
#################################################################
# Name:         pluginupdate.sh	      Version:      0.3.0       #
# Created:      02.12.2020            Modified:     08.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      download latest plugins                         #
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""                       #
VERSION=""			#
#########################################

#### ADJUST PLUGINS TO DOWNLOAD HERE ####
#########################################
ESSENTIALSX="false"			#
ESSENTIALSX_CHAT="false"		#
ESSENTIALSX_XMPP="false"		#
ESSENTIALSX_SPAWN="false"		#
ESSENTIALSX_GEOIP="false"		#
ESSENTIALSX_PROTECT="false"		#
ESSENTIALSX_ANTIBUILD="false"		#
LUCKPERMS="false"			#
FAWE="false"				#
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)	 #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### STATIC VARIABELS ###########################
SERVERTYPE=""					#
UDIR=~/$SERVER/scripts/update/			#
UPDIR=~/$SERVER/scripts/update/plugins/		#
NPDIR=~/$SERVER/scripts/update/plugins/new/	#
MPDIR=~/$SERVER/scripts/update/plugins/man/	#
TPDIR=~/$SERVER/scripts/update/plugins/temp/	#
#################################################

#### CHECK SETUP ################################################
for VAR in "$SERVER" "$VERSION"					#
 do								#
  if [ "$SERVER" == "" ]                                	#
   then                                                 	#
    printf "[$RED EXIT $NORMAL] SERVER or VERSION not set!\n"	#
    exit                                          	      	#
  fi                                                    	#
done								#
#################################################################

#### CHECK DIRS ROUTINE #########################################################
for DIR in $UDIR $UPDIR $NPDIR $MPDIR $TPDIR                                    #
 do                                                                     	#
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
done                                                                    	#
#################################################################################

#### SKIP IF VANILLA SERVER NO PLUGINS ##################################
if [ $SERVERTYPE == "vanilla" ] || [ $SERVERTYPE == "snapshot" ]	#
 then                                   				#
  printf "[ SKIP ] vanilla, no plugins.\n"				#
  exit                                  				#
fi                  			                		#
#########################################################################

#### CHECK VERSION  #############################################################################
if [ "$VERSION" != "1.18.1" ] || [ "$VERSION"  != "1.17.1" ]									# add compatibility list
 then												#
  printf "[$RED SKIP $NORMAL] pluginupdate.sh is not compatible with $RED $VERSION $NORMAL\n"	#
  printf "[$RED WARN $NORMAL] trying anyway\n"							#
fi												#
#################################################################################################

#### CHECK IF SERVER IS RUNNING IF SO INFORM USERS ON SERVER ####################
RUN=$(screen -list | grep -o "$SERVER")                                         #
if [ "$RUN" == "$SERVER" ]                                                      #
 then                                                                           #
  printf "[ INFO ] $SERVER is running... also informing users...\n" 	  	#
  screen -S $SERVER -X stuff 'say [Info] downloading Plugin updates...\n'	#
fi                                                                              #
#################################################################################

#### EssentialsX ################################################################################################################################################ # implement get only on version change ?
#### CHECK WITCH ESSENTIALS PLUGINS SHOULD BE DOWNLOADED ################################################################################################	#
for DOWNLOAD in $ESSENTIALSX $ESSENTIALSX_CHAT $ESSENTIALSX_XMPP $ESSENTIALSX_SPAWN $ESSENTIALSX_GEOIP $ESSENTIALSX_PROTECT $ESSENTIALSX_ANTIBUILD	#	#
 do																			#	#
  case "$DOWNLOAD" in																	#	#
   true)																		#	#
    SKIP="false";;																	#	#
   false)																		#	#
    if [ "$SKIP" == "false" ]																#	#
     then																		#	#
      SKIP="false"																	#	#
     else																		#	#
      SKIP="true"																	#	#
    fi;;																		#	#
   *)																			#	#
    printf "[$RED WARN $NORMAL ] adjust pluginvariables in ./pluginupdate.sh properly!\n"								#	#
    printf "[$RED SKIP $NORMAL ] set to \"true\" or \"false\" abort...\n"										#	#
    exit;;																		#	#
  esac																			#	#
done																			#	#
#########################################################################################################################################################	#
#### CHECK IF ESSENTIALSX IS SELECTED AS DEPENDENCY #############################################								#
if [ "$SKIP" == "false"  ] && [ "$ESSENTIALSX" == "false" ]					#								#
 then												#								#
  printf "[$YELLOW WARN $NORMAL] EssentialsX is needed as dependency!\n"			#								#
  printf "[ INFO ] also installing EssentialsX...\n"						#								#
  ESSENTIALSX="true"										#								#
  sed -i "s|ESSENTIALSX=\"false\"|ESSENTIALSX=\"true\"|" ~/$SERVER/scripts/pluginupdate.sh	#								#
  printf "[$GREEN DONE $NORMAL] changed ESSENTIALSX=\"false\" to \"true\"\n"			#								#
fi												#								#
#################################################################################################								#
#### GETING ESSENTIALSX #########################################################################################################				#
if [ "$SKIP" == "false" ]													#				#
 then																#				#
  printf "[ INFO ] downloading latest EssentialsX ...\n"									#				#
  cd $TPDIR															#				#
  wget -O EssentialsX.zip https://ci.ender.zone/job/EssentialsX/lastStableBuild/artifact/jars/*zip*/jars.zip -q --show-progress	#				#
  unzip EssentialsX.zip > /dev/null												#				#
  cd jars															#				#
  if [ "$ESSENTIALSX" == "true" ]												#				#
   then																#				#
    mv EssentialsX-*.jar $NPDIR													#				#
  fi																#				#
  if [ "$ESSENTIALSX_CHAT" == "true" ]												#				#
   then																#				#
    mv EssentialsXChat-*.jar $NPDIR												#				#
  fi																#				#
  if [ "$ESSENTIALSX_SPAWN" == "true" ]												#				#
   then																#				#
    mv EssentialsXSpawn-*.jar $NPDIR												#				#
  fi																#				#
  if [ "$ESSENTIALSX_PROTECT" == "true" ]											#				#
   then																#				#
    mv EssentialsXProtect-*.jar $NPDIR												#				#
  fi																#				#
  if [ "$ESSENTIALSX_XMPP" == "true" ]												#				#
   then																#				#
    mv EssentialsXXMPP-*.jar $NPDIR												#				#
  fi																#				#
  if [ "$ESSENTIALSX_GEOIP" == "true" ]												#				#
   then																#				#
    mv EssentialsXGeoIP-*.jar $NPDIR												#				#
  fi																#				#
  if [ "$ESSENTIALSX_ANTIBUILD" == "true" ]											#				#
   then																#				#
    mv EssentialsXAntiBuild-*.jar $NPDIR											#				#
  fi																#				#
 else																#				#
 printf "[ SKIP ] EssentialsX not selected...\n"										#				#
fi																#				#
#################################################################################################################################################################

#### LUCK PERMS #################################################################################################################################
if [ "$LUCKPERMS" == "true" ]															#
 then																		#
  cd $TPDIR																	#
  printf "[ INFO ] downloading latest LuckPerms...\n"												#
  wget -O LuckPermsBukkit.zip https://ci.lucko.me/job/LuckPerms/lastStableBuild/artifact/bukkit/loader/build/libs/*zip*/libs.zip -q --show-progress #
  unzip LuckPermsBukkit.zip > /dev/null														#
  cd libs																	#
  mv LuckPerms-Bukkit-*.jar $NPDIR														#
  SKIP="false"																	#
 else																		#
  printf "[ SKIP ] LuckPerms not selected...\n"													#
fi																		#
#################################################################################################################################################

#### FAST ASYNC WORLD EDIT ##############################################################################################################
if [ "$FAWE" == "broken" ]														# broken link not working new ?
 then																	#
  FVERSION=$(echo "$VERSION" | cut -d\. -f1,2)												#
  printf "[ INFO ] downloading latest FastAsyncWorldEdit...\n"										#
  cd $TPDIR																#
  wget -O FAWE.zip https://ci.athion.net/job/FastAsyncWorldEdit-$FVERSION/lastStableBuild/artifact/*zip*/archive.zip 	#
  unzip FAWE.zip > /dev/null														#
  cd archive/worldedit-bukkit/build/libs/												#
  mv FastAsyncWorldEdit-$FVERSION-*.jar $NPDIR												#
  SKIP="false"																#
 else																	#
  printf "[ SKIP ] FastAsyncWorldEdit not selected...\n"										#
fi																	#
#########################################################################################################################################

#### World EDIT #############
# no permalink -> manual... #
#############################

#### VAULT ##################
# no permalink -> manual... #
#############################

#### CHEST SHOP #################################################################################################################
#  printf "[ INFO ] downloading latest ChestShop ...\n"										#
#  cd $TPDIR															#
#  wget -O ChestShop.zip https://ci.minebench.de/job/ChestShop-3/lastStableBuild/artifact/*zip*/archive.zip > /dev/null 2>&1	#
#  unzip ChestShop.zip > /dev/null												#
#  cd archive/target/														#
#  mv ChestShop.jar $NPDIR													#
#  SKIPP="false"
#################################################################################################################################

#### CLEAN UP TEMP FILES AND DISPLAY INFO ###############################################
#########################################################################################
if [ "$SKIP" == "false" ]								#
 then											#
  cd $TPDIR										#
  rm *.zip										#
  rm -r *	# EssentialsX								#
  printf "[$GREEN DONE $NORMAL] update ready apply with ./applyupdate.sh \n"		#
 else											#
  printf "[ INFO ] plugins to download can be selected with ./selectplugins.sh\n"	#
  printf "[$GREEN DONE $NORMAL] nothing to do... no plugins selected...\n"		#
fi											#
#########################################################################################

#### IF SERVER IS RUNNING IF SO INFORM USERS ON SERVER ##################
#########################################################################
if [ "$RUN" == "$SERVER" ]                                              #
 then                                                                   #
  screen -S $SERVER -X stuff 'say [Info] Download erfolgreich!\n'	#
fi                                                                      #
#########################################################################

#### EOF ####
