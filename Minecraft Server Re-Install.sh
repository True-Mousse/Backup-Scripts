#!/bin/bash
##################################################################
# Script designed to re-install Minecraft on a new Ubuntu Server. 
#
# 1) Installs Java 19, cron, & nano packages 
# 2) Create user: minecraft
# 3) Extract minecraft backup "The-World" 
# 4) Creates minecraft.service 
# 5) Creates cronjob under minecraft user  
# 6) Open UFW port 25565/tcp
#
# A thank you to Nicky Matthew for the template for the minecraft.service @ 
# https://bobcares.com/blog/install-minecraft-server-on-ubuntu/ 
##################################################################

apt install openjdk-19-jre-headless nano cron -y

##################################################################
# Creates: 
#   System User Account: minecraft 
#   Group: minecraft
#   Home Directory: /opt/minecraft
#   Login Shell: /bin/bash 
##################################################################
useradd -rmUd /opt/minecraft -s /bin/bash minecraft 

# Extract Minecraft Backup "The World" to / 
tar -xzvf The-World*.tgz -C /

# Creates the minecraft.service file
cat <<EOF >/etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
Nice=1
KillMode=none
SuccessExitStatus=0 1
ProtectHome=true
ProtectSystem=full
PrivateDevices=true
NoNewPrivileges=true
WorkingDirectory=/opt/minecraft/server
ExecStart=/usr/bin/java -Xmx10G -Xms1024M -jar paper.jar nogui
ExecStop=/opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p STRONG-PASSWORD stop

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable minecraft

# Define the cron job
cron_job="
## Minecraft Backup Run Daily @ 0200 ##
0 2 * * * /opt/minecraft/tools/Minecraft_Backup.sh"

# Create a temporary file for the modified crontab
temp_cron=$(mktemp)

# Copy the current crontab of the minecraft user to the temporary file
crontab -u minecraft -l > "$temp_cron"

# Append the new cron job to the temporary file 
echo "$cron_job" >> "$temp_cron"

# Load the modified crontab from the temporary file for the minecraft user
crontab -u minecraft "$temp_cron"

uwf allow 25565/tcp
