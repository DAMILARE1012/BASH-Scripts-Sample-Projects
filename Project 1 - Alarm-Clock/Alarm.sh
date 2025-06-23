#!/bin/bash 

# Written By Woland, Improved by OLATUNJI Damilare Emmanuel 

## About the Project - (Simple Alarm clock script)
	# This script is designed to help you wake up at a specific time.
	# It uses the figlet command to print text in ascii art and the mpv command to play audio files.
	# It also uses the sleep command to pause the script for a given time.
	# It also uses the date command to log the time of the alarm.
	# It also uses the cd command to change the directory to the alarm_files directory.
	# It also uses the alarm_logs directory to log the time of the alarm.


#Dependency:
#          mpv   - The purpose is to play audio files
#          figlet - The purpose is to print text in ascii art
#          sleep - The purpose is to pause the script for a given time

# Check if the user provided a time duration. If not, throw an error.
if [[ -z $1 ]]; then
	echo -e "\n\t Error: You're required to provide time duration."
	echo -e "\n\t Usage: ./Alarm.sh 8h for 8 hours of sleep"
	echo -e "\t\t./Alarm.sh 20m for 20 minutes of sleep \n"
	exit 0
fi

# Validate time format (e.g. 10s, 5m, 2h, 1d or combinations like 1h5m30s)
if ! [[ $1 =~ ^([0-9]+[smhd])+$ ]]; then
    echo -e "\n\t Error: Invalid time format."
    echo -e "\t Example valid formats: 10s, 5m, 2h, 1d, 1h30m"
    echo -e "\t See 'man sleep' for more info.\n"
    exit 1
fi

# Sleep for the duration of the alarm.
sleep "$1";

# Log the time of the alarm.
LOGFILE="./alarm_logs/alarm_log.log"
echo "$(date): Alarm started for duration $1" >> "$LOGFILE"

# Change the directory to the alarm_files directory.
cd ./alarm_files

# Check if the alarm files exist. If not, throw an error.
# Check if alarm files exist before thinking to use them. If not, throw an error.
if ! [[ -f alarm1.mp3 && -f alarm2.mp3 && -f alarm3.mp3 && -f alarm4.mp3 && -f alarm5.mp3 ]]; then
    echo -e "\n\t Error: Alarm files not found."
    echo -e "\t Please ensure alarm1.mp3, alarm2.mp3, alarm3.mp3, alarm4.mp3, and alarm5.mp3 exist in the same directory as this script.\n"
    exit 1
fi

cd ..
# If the files exist, then we can use them.
alarm=(
	"./alarm_files/alarm1.mp3"
	"./alarm_files/alarm2.mp3"
	"./alarm_files/alarm3.mp3"
	"./alarm_files/alarm4.mp3"
	"./alarm_files/alarm5.mp3"
)

# Configuration options 
for ((i=0; i<${#alarm[@]}; i++)); do
  figlet -f slant "Its Time To Wake Up-$((i+1))"
  echo "$(date): Playing alarm sound: ${alarm[i]} started" >> "$LOGFILE"
  figlet "sleep time over"
  sleep 1; mpv --no-audio-display --no-resume-playback "${alarm[i]}" &
  figlet -f slant "Wake Up-$((i+1))"
  figlet "sleep time over"
  sleep 45; killall mpv
  sleep 5m;
done

# Log the time of the alarm.
echo "$(date): Alarm sequence finished" >> "$LOGFILE"
