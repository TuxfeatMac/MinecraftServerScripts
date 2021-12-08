#!/bin/bash
#################################################################
# Name:         selectplugins.sh      Version:      0.0.3       #
# Created:      20.12.2020            Modified:     08.12.2021  #
# Author:       Joachim Traeuble                                #
# Purpose:      modify pluginupdate.sh / setup manual plugins	#
#################################################################

#### ADJUST SERVER VARIABELS HERE #######
#########################################
SERVER=""			#
VERSION=""			#
#########################################

#### SET SOME COLOURS ####
NORMAL=$(tput sgr0)      #
RED=$(tput setaf 1)      #
GREEN=$(tput setaf 2)    #
YELLOW=$(tput setaf 3)   #
##########################

#### STATIC VARIABELS ###########################
SCDIR=~/$SERVER/scripts               	   	#
MPDIR=~/$SERVER/scripts/update/plugins/man	#
SPDIR=~/$SCRIPTS/plugins/common/		# see PluginList.txt
SERVERTYPE=""				#
SCRIPTS=""				#
#################################################

#### CHECK SETUP ########################################################
for VAR in "$SERVER" "$SCRIPTS"	"$VERSION"				#
 do                                                     		#
  if [ "$VAR" == "" ]	                                		#
   then                                                 		#
    printf "[$RED EXIT $NORMAL] SERVER, VERSION or SCRIPTS not set!\n"	#
    exit                               			                #
  fi                                                   			#
done                                                    		#
#########################################################################

#### SKIP IF VANILLA SERVER NO PLUGINS ##
if [ $SERVERTYPE == "vanilla" ]         #
 then                                   #
  exit                                  #
fi                                      #
#########################################

#### DISPLAY INFOS ######################
printf "[ INFO ] modify plugins...\n"	#
#########################################

#### COMMON MANUAL PLUGINS ######################################
#################################################################

#### VAULT 1.7.3 ################################################
read -n 1 -p "[  IN  ] [ y / n ] Install Vault? : " VAULT	#
case "$VAULT" in                                                #
 y)                                                             #
  cp $SPDIR/Vault*.jar $MPDIR/					#
  printf "\n";;							#
 n)								#
  rm $MPDIR/Vault*.jar > /dev/null 2>&1				#
  printf "\n";;							#
 *)								#
  printf "bla....\n";;						#   implement
esac								#   rm on unselect
#################################################################

#### HARBOR 1.6.4 ###############################################
#read -n 1 -p "[  IN  ] [ y / n ] Install Harbor? : " HARBOR	#
#if [ "$HARBOR" == "y" ]					#
# then								#
#  cp $SPDIR/Harbor*.jar $MPDIR/				#
#  printf "\n"							#
#  printf "\n[$GREEN DONE $NORMAL] copied Harbor in place...\n"	#
# cp common config.yml ? ####					#
# else								#
#  printf "\n"							#
#fi								#   in 1.17 not neded any more -> Gamerule
#################################################################

#### COREPROTECT 20.1 ################################################### not working dependencies broken ?
#read -n 1 -p "[  IN  ] [ y / n ] Install CoreProtect? : " COREPROTECT	#
#if [ "$COREPROTECT" == "y" ]						#
# then									#
#  cp $SPDIR/CoreProtect-20.1*.jar $MPDIR/				#
#  printf "\n"								#
#  printf "\n[$GREEN DONE $NORMAL] copied in place...\n"		#
# cp common config.yml ? ####						#
# else									#
#  printf "\n"								#
#fi									#
#########################################################################

#### AUTOMATIC DOWNLOADABLE PLUGINS #############################################
#################################################################################

#### LUCKPERMS ##################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install LuckPerms? : " LUCKPERMS		#
if [ "$LUCKPERMS" == "y" ]							#
 then										#
  sed -i "s|LUCKPERMS=\"false\"|LUCKPERMS=\"true\"|" $SCDIR/pluginupdate.sh	#
  printf "\n"									#
 else										#
  printf "\n"									#
fi										#
#################################################################################

#### FASTASYNCWORLDEDIT #########################################################
#read -n 1 -p "[  IN  ] [ y / n ] Install FastAsyncWorldEdit? : " FAWE		#
#if [ "$FAWE" == "y" ]								#
# then										#
#  sed -i "s|FAWE=\"false\"|FAWE=\"true\"|" $SCDIR/pluginupdate.sh		#
#  printf "\n"									#
# else										#
#  printf "\n"									#
#fi										#
################################################################################# link broken

#### ESSENTIALSX ########################################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX? : " ESSENTIALSX					#
if [ "$ESSENTIALSX" == "y" ]										#
 then													#
  sed -i "s|ESSENTIALSX=\"false\"|ESSENTIALSX=\"true\"|" $SCDIR/pluginupdate.sh				#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#### ESSENTIALSX CHAT ###################################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX-Chat? : " ESSENTIALSX_CHAT 			#
if [ "$ESSENTIALSX_CHAT" == "y" ]									#
 then													#
  sed -i "s|ESSENTIALSX_CHAT=\"false\"|ESSENTIALSX_CHAT=\"true\"|" $SCDIR/pluginupdate.sh		#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#### ESSENTIALSX SPAWN ##################################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX-Spawn? : " ESSENTIALSX_SPAWN 			#
if [ "$ESSENTIALSX_SPAWN" == "y" ]									#
 then													#
  sed -i "s|ESSENTIALSX_SPAWN=\"false\"|ESSENTIALSX_SPAWN=\"true\"|" $SCDIR/pluginupdate.sh		#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#### ESSENTIALSX PROTECT ################################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX-Protect? : " ESSENTIALSX_PROTECT			#
if [ "$ESSENTIALSX_PROTECT" == "y" ]									#
 then													#
  sed -i "s|ESSENTIALSX_PROTECT=\"false\"|ESSENTIALSX_PROTECT=\"true\"|" $SCDIR/pluginupdate.sh 	#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#### ESSENTIALSX ANTIBUILD ##############################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX-AntiBuild? : " ESSENTIALSX_ANTIBUILD 		#
if [ "$ESSENTIALSX_ANTIBUILD" == "y" ]									#
 then													#
  sed -i "s|ESSENTIALSX_ANTIBUILD=\"false\"|ESSENTIALSX_ANTIBUILD=\"true\"|" $SCDIR/pluginupdate.sh	#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#### ESSENTIALSX GEOIP ##################################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX-GeoIP? : " ESSENTIALSX_GEOIP 			#
if [ "$ESSENTIALSX_GEOIP" == "y" ]									#
 then													#
  sed -i "s|ESSENTIALSX_GEOIP=\"false\"|ESSENTIALSX_GEOIP=\"true\"|" $SCDIR/pluginupdate.sh       	#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#### ESSENTIALSX XMPP ###################################################################################
read -n 1 -p "[  IN  ] [ y / n ] Install EssentialsX-XMPP? : " ESSENTIALSX_XMPP 			#
if [ "$ESSENTIALSX_XMPP" == "y" ]									#
 then													#
  sed -i "s|ESSENTIALSX_XMPP=\"false\"|ESSENTIALSX_XMPP=\"true\"|" $SCDIR/pluginupdate.sh       	#
  printf "\n"												#
 else													#
  printf "\n"												#
fi													#
#########################################################################################################

#### DISPLAY FINAL INFOS ################################################################
printf "[$GREEN DONE $NORMAL] updated ./pluginupdate.sh, copied manaual plugins\n"	#
#########################################################################################

#### EOF ####