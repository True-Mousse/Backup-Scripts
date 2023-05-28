#!/bin/bash

sudo apt update && sudo apt upgrade -y

#Installs Java 19 
sudo apt install openjdk-19-jre-headless

#Creates: 
    # System User Account: minecraft 
    # Group = minecraft
    # Home Directory = /opt/minecraft
    # Login Shell = /bin/bash 
sudo useradd -rmUd /opt/minecraft -s /bin/bash minecraft 