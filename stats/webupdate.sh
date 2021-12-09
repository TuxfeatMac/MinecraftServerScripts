# !/bin/bash
#################################################################
# Name:         dynwebupdate.sh        Version:      0.0.3      # <= early alpha
# Created:      09.12.2021             Modified:     09.12.2021 #
# Author:       Joachim Traeuble                                #
# Purpose:      generate html sites for all online servers      #
#################################################################

#### SET SERVERSNAMES GET COUNT AND NAMES ###############################
SERVERS=$(sudo -u minecraft screen -list | cut -d '.' -f 2 | cut -f 1 | cut -d ':' -f 2 | xargs)

#### SCRIPT IS MENT TO BE TO RUN AS ROOT! NOT AS PI WITH SUDO ###########################################################################
if [ $USER != root ]
 then
  printf "${RED}PLEASE RUN THIS SCRIPT AS ROOT! DONT USE SUDO! $NORMAL \n"
  exit
fi
printf " $YELLOW
====================================================================
!    PLEASE DONT USE SUDO, USE SU TO LOGIN TO THE ROOT USER        !
! PLEASE STOP THIS SCRIPT NOW WITH CONTROL+C IF YOU ARE USING SUDO !
!               CONTINUING SETUP IN 5 SECONDS...                   !
====================================================================
$NORMAL\n" && sleep 5

read -p "[  IN  ] update statistic webserver with running servers? :" CONFIRM
if [ "$CONFIRM" != "y" ]
 then
 printf "abort.\n"
  exit
fi

### CLEAN HTML DIR, REMOVES OFFLINE SERVERS
rm -R /var/www/html/*

#### CREATING DIR FOR EACH SERVER AND ADDING SERVER.HTML ################################################################################################################################################
for SERVER in $SERVERS
 do

mkdir -p /var/www/html/$SERVER

sudo printf " <!DOCTYPE html>
<html>
<head>
        <title> $SERVER - Statistics </title>
</head>
<body>
        <h2> $SERVER </h2>
        <hr style=\"width:100\%;text-align:left;margin-left:0\">
        <p> <img src=\"/$SERVER/$SERVER-Player-1d.png\" alt=\"Player-1h-PNG-GERN-FAILED\"> <img src=\"/$SERVER/$SERVER-Player-1w.png\" alt=\"Player-1w PNG GERN FAILED\"> <img src=\"/$SERVER/$SERVER-Player-1m.png\" alt=\"Player-1m PNG GERN FAILED\">  </br>
        <hr style=\"width:100\%;text-align:left;margin-left:0\">
        <p> <img src=\"/$SERVER/$SERVER-TPS-1d.png\" alt=\"TPS-1h PNG-GERN-FAILED\">       <img src=\"/$SERVER/$SERVER-TPS-1w.png\" alt=\"TPS-1w PNG GERN FAILED\">       <img src=\"/$SERVER/$SERVER-TPS-1m.png\" alt=\"TPS-1h PNG GERN FAILED\">  </br>
        <hr style=\"width:100\%;text-align:left;margin-left:0\">
        <p> <img src=\"/$SERVER/$SERVER-RAM-1d.png\" alt=\"RAM-1h-PNG-GERN-FAILED\">       <img src=\"/$SERVER/$SERVER-RAM-1w.png\" alt=\"RAM-1w PNG GERN FAILED\">       <img src=\"/$SERVER/$SERVER-RAM-1m.png\" alt=\"RAM-1m PNG GERN FAILED\">  </br>
</body>
</html>
" > /var/www/html/${SERVER}.html


printf "[ DONE ] $SERVER $SERVER.html \n"
done

#### CREAING MAIN INDEX.HTML WITH LINK TO EVERY ONLINE SERVER #####################################
sudo printf "<!DOCTYPE html>
<html>
<head>
        <title>Minecraft Server Stats Overview</title>
</head>
<body>
        <h2>Minecraft Server Stats Overview</h2>
" > /var/www/html/index.html

for SERVER in $SERVERS
 do
  sudo printf "       <h3> > <a href=\"/$SERVER.html\">$SERVER</a> </h3>\n" >> /var/www/html/index.html
done

sudo printf "</body>
</html>" >> /var/www/html/index.html


#### GENERATING AND UPDATING NEW GRAPHS ####

#sudo /home/minecraft/$SERVER/scripts/rrd-graph-for-alpha.sh



