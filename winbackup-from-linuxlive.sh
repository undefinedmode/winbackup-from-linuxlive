#!/bin/bash
# v2016-09-17 https://github.com/undefinedmode 
##########################################################################################################################################################
echo "Bash script to backup windows (7 or later) data to an external drive from a Linux live distro"
timestamp=$(date +%F_%H%M%S)
echo "$timestamp"
	echo -e "\e[105mMount windows partition and make sure you have enough free space on your external drive:\e[00m"
df -h | grep -Ei "(Filesys|dev/s|home)"

##########################################################################################################################################################
echo "What is the the path for the C drive?"
read -r sourcedir
# check validity sourcedir
if [ -d "$sourcedir"/Users ]
then
	echo -e "\e[101mUsers directory exists\e[00m"
else
	echo -e "\e[101mERROR: Users folder does not exist. Wrong source folder\e[00m"
	exit
fi

# Destination dir
echo "What is the the path for your external media?"
read -r tempdestdir
destdir="$tempdestdir/$timestamp"
mkdir -p "$destdir"

echo "Please name this project"
read -r projname
echo "$projname" > "$destdir"/00readme.txt	
##########################################################################################################################################################
	echo -e "\e[105mStarting backup\e[00m"

# Drivers #C:\Windows\Windows/System32 in the sub-folders Drivers, DriverStore and DRVSTORE (if any).
tar -zcvf "$destdir"/"$timestamp"-drivers.tgz "$sourcedir"/Windows/System32/Drivers "$sourcedir"/Windows/System32/drivers $sourcedir/Windows/System32/DriverStore $sourcedir/Windows/System32/DRVSTORE


# Appdata (backup appdata for every non-default user
tar --exclude='./folder' --exclude='$sourcedir/Users/UpdatusUser' --exclude='$sourcedir/Users/All Users' --exclude='$sourcedir/Users/Default' --exclude='$sourcedir/Users/Default User' -zcvf "$destdir"/"$timestamp"-appdata.tgz $sourcedir/Users/

# List folder contents (Program Files etc)
ls -la "$sourcedir/Program Files (x86)" > "$destdir/$timestamp-programfilesx86.txt"
ls -la "$sourcedir/Program Files" > "$destdir/$timestamp-programfiles.txt"

	echo -e "\e[105mDestination folder content is the following: \e[00m"
ls -la "$destdir"
	echo -e "\e[105mBackup completed.\e[00m"
