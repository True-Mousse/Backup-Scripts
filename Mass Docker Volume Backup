#!/bin/bash

# Stop all Docker containers 
docker stop $(docker ps -aq)

# Get a list of all Docker volumes
volumes=$(docker volume ls -q)

# Loop through each Volume and bac up as tar file
for volume in $volumes; do

    # Get the Volume name
    volume_name=$(docker volume inspect --format '{{.Name}}' $volume)

    # Name of Backup tar file w/ date 
    backup_file="${volume_name}_backup_$(date +"%Y-%m-%d").tar.gz"

    # Directory to Backups
    backup_dir=/mnt/Spare/docker_backups/$(date +"%Y-%m-%d")

    # Backup the Volume to a tar file
    docker run --rm --mount source=${volume_name},target=/data -v $backup_dir:/backup busybox tar -czvf /backup/$backup_file /data

    echo -e "\nBackup of $volume_name complete. Stored in $backup_file \n"
done

# Start all Docker containers
docker start $(docker ps -aq)

## Restore a Docker Volume from Backup
# docker run --rm --mount source=test_volume,target=/data -v $(pwd):/backup busybox tar -xzvf /backup/dokuwiki_config_backup_2024-01-17.tar.gz -C /
