#!/bin/bash




BACKUP_UUID=2d558526-b6a1-459d-8a23-2d894c9dab1e
PI_UUID=8b39cf7c-ad6f-4608-a80e-a6807e80bc87

sudo apt update
sudo apt upgrade
sudo pip install -U pip
sudo apt install docker-compose

## 1. Installing docker 
curl -sSL https://get.docker.com | sh

## 2. Adding user to docker grp
sudo usermod -aG docker $USER

## Making mount points
sudo mkdir /mnt/pi /mnt/backup

## Adding fstab entries
echo "UUID=$PI_UUID  /mnt/pi               ext4    defaults,noatime  0       1" >> /etc/fstab
echo "UUID=$BACKUP_UUID  /mnt/backup               ext4    defaults,noatime  0       1" >> /etc/fstab

## Mounting
sudo mount -a

## Making pi folders if not already there
mkdir /mnt/pi/meta
mkdir /mnt/pi/cache
mkdir /mnt/pi/downloads

## 3. Installing portainer
sudo docker pull portainer/portainer-ce:latest

## 4. Running Portainer 
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /mnt/pi/meta/portainer_data:/data portainer/portainer-ce:latest

## Disable resolve
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved

## Running pihole
docker-compose -f $YAML_DIR/pihole.yml up -d


