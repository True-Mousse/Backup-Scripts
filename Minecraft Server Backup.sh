#!/bin/bash
##################################################################
# Script used to backup MC server to external HDD.
# Backups older than 14x days are removed. 
#
# mcrcon package is provided by: https://github.com/Tiiffi/mcrcon
#
# A thank you to Nicky Matthew for providing a tutorial and examples @ 
# https://bobcares.com/blog/install-minecraft-server-on-ubuntu/ 
#  
##################################################################

rcon(){
     /opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p STRONG-PASSWORD "$1"
}

## Minecraft command that disables the server writing to the world files.
rcon "save-off"

## Minecraft command that saves the server to the data storage device.
rcon "save-all"

tar -czf /mnt/spare1/minecraft/backups/The-World-$(date +%F-%H-%M).tgz /opt/minecraft

## Minecraft command that enables server writing to the world files.
rcon "save-on"

## Delete backups older than 14 days
find /mnt/spare1/minecraft/backups/ -type f -mtime +14 -name '*.tgz' -delete
