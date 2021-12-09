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

0. crontab -e

@reboot /home/"USERNAME"/"SERVER-1"/scripts/start.sh -b

@reboot /home/"USERNAME"/"SERVER-n"/scripts/start.sh -b

1 0 * * * /home/"USERNAME"/"SERVER-1"/scripts/dailyrestart.sh

9 0 * * * /home/"USERNAME"/"SERVER-n"/scripts/dailyrestart.sh



Notes
Errors according to missing scripts are fine, since I have not uploaded all scripts yet.
These scripts are so far functional and have some input protection. However they are still in "alpha" stage at the moment.
So use them at your own risk.
