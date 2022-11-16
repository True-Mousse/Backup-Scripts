#!/bin/bash

function rcon 
{
/opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p PASSWORD “$1”
}

## Minecraft command that disables the server writing to the world files.
rcon “save-off”

## Minecraft command that saves the server to the data storage device.
rcon “save-all”


tar -czf /opt/minecraft/backups/server-$(date +%F-%H-%M).tar.gz /opt/minecraft/server

## Minecraft command that enables server writing to the world files.
rcon “save-on”

## Delete older backups
find /opt/minecraft/backups/ -type f -mtime +14 -name '*.gz' -delete
