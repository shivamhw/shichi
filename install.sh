#!/bin/bash




BACKUP_UUID=2d558526-b6a1-459d-8a23-2d894c9dab1e
PI_UUID=8b39cf7c-ad6f-4608-a80e-a6807e80bc87

## Preq
echo "Updating Stuff...."
sudo apt update
sudo apt upgrade
sudo pip install -U pip
sudo apt install docker-compose

## Static IP
## User accounts 
## SSH VNC ARM OVERCLOCK

## 1. Installing docker 
echo "Installing Docker..."
curl -sSL https://get.docker.com | sh

## 2. Adding user to docker grp
echo "Adding docker grp"
sudo usermod -aG docker $USER
sudo systemctl enable --now docker 

## Making mount points
echo "Making Mount points"
sudo mkdir /mnt/pi /mnt/backup

## Adding fstab entries
echo "Adding fstab entries"
echo "UUID=$PI_UUID  /mnt/pi               ext4    defaults,noatime  0       1" | sudo  tee -a /etc/fstab
echo "UUID=$BACKUP_UUID  /mnt/backup               ext4    defaults,noatime  0       1" | sudo tee -a /etc/fstab

## Unmounting incase automount
echo "Umounting stuff..."
sudo umount /media/$USER/*

## Mounting
echo "Mounting HDD"
sudo mount -a

## Making pi folders if not already there
echo "Making dir for pi"
mkdir /mnt/pi/meta
mkdir /mnt/pi/cache
mkdir /mnt/pi/downloads
mkdir /mnt/pi/local_media

## 3. Installing portainer
echo "Pulling Portainer"
sudo docker pull portainer/portainer-ce:latest

## 4. Running Portainer 
echo "Running Portainer.."
sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /mnt/pi/meta/portainer_data:/data portainer/portainer-ce:latest

## Disable resolve
echo "disable resolvd"
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved

## Running pihole
echo "running pihole..."
docker-compose -f $YAML_DIR/pihole.yml up -d


