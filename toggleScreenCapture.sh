#!/bin/bash
pidOfFFMPEG=$(ps aux | grep -i 'ffmpeg -f x11grab' | grep -v 'grep' | awk '{print $2}')
pathToOutput="/home/razz1k/Videos"

if [ -z $pidOfFFMPEG ]; then
  ffmpeg \
-f x11grab -i :0.0 \
-f pulse -i default -ac 2 -af "highpass=f=100, lowpass=f=3000, volumedetect, volume=2" \
-c:a aac -b:a 160k \
-c:v libx264 -preset slow -crf 10 -movflags +faststart -nostdin -loglevel panic \
$pathToOutput/screenCapture_$(date +'%H-%M-%S').mkv &
else
  sleep 1 && kill $pidOfFFMPEG &
fi
