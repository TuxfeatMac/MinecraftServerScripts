Do not run script's as root!
Use a local user.
Script's musst be placed in home directory.

0. cd ~
1. wget https://github.com/TuxfeatMac/MinecraftServerScripts/archive/refs/heads/0_3_0.zip
2. unzip 0_3_0.zip
3. cd MinecraftServerScripts-0_3_0
4. ./setup.sh
5. Follow instructions.
6. Enjoy your MinecraftServer

or

0. cd ~
1. git clone https://github.com/TuxfeatMac/MinecraftServerScripts
2. cd MinecraftServerScripts
3. nano setup.sh
4. change line: SCRIPTS="MinecraftServerScripts-0_3_0"   to: SCRIPTS="MinecraftServerScripts" 
5. ./setup.sh
6. Follow instructions.

Auto start / daily backup / update / restart via crontab

0. run ~/"SERVER"/scripts/backup once mannualy to create nessesary backup dirs!
1. you may want to addjust the maximum backup size in backup.sh
2. crontab -e

@reboot /home/"USERNAME"/"SERVER-1"/scripts/start.sh -b

@reboot /home/"USERNAME"/"SERVER-n"/scripts/start.sh -b

1 0 * * * /home/"USERNAME"/"SERVER-1"/scripts/dailyrestart.sh

9 0 * * * /home/"USERNAME"/"SERVER-n"/scripts/dailyrestart.sh



Notes

Errors according to missing scripts are fine, since I have not uploaded all scripts yet.
These scripts are so far functional and have some input protection. However they are still in "alpha" stage at the moment.
So they are not perfect any may not work with your system, use them at your own risk... (for me the most of them worked for over a year now)


TLDR => place your coustum plugins in --> ~/"SERVER"/scripts/updates/plugins/man/"YourManualAddedPlugin".jar , then run ./applayupdate.sh once. 
If you want to install manual plugins there is one caviat. The pluginupdate.sh will prefetch automatic downloadable plugins.
The applayupdate.sh will delete all plugins located in ~/"SERVER"/plugins/*.jar ! 
After deletion the whole pluginset in ~/"SERVER"/scripts/update/plugins/new + ~/"SERVER/scripts/update/plugins/man" wil be copied over to ~/"SERVER/plugins/"


Example crontab entrys to automate everything
#### MineCraft Server Scripts
## start servers at rebbot
@reboot minecraft /home/minecraft/Paper/start.sh -b
## update rrd's for running servers and generate graphs and copy to html
*/1 * * * * minecraft /home/minecraft/Paper/scripts/serverstats.sh
*/1 * * * * minecraft /home/minecraft/Paper/scripts/rrd-graph-all.sh
*/1 * * * * root /home/minecraft/Paper/scripts/copygraphshtml.sh
## check for vanished / new servers and update index.html
*/5 * * * * root /home/minecraft/Paper/scripts/htmlupdate.sh
#
